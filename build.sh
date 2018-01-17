#!/bin/sh

set -e 

BUILD_DEPS='bzip2 curl gcc libbz2-dev libgdbm-dev libc6-dev libreadline6-dev libsqlite3-dev libssl-dev make zlib1g-dev'

# install build dependencies
apt-get update
apt-get install -y $BUILD_DEPS --no-install-recommends
rm -rf /var/lib/apt/lists/*

# download sources
mkdir -p /usr/src/python
curl -s https://bitbucket.org/stackless-dev/stackless/get/v3.5.3-slp.tar.bz2 | tar -xjC /usr/src/python --strip-components=1

# build and install
cd /usr/src/python
./configure --prefix=/opt/stackless
make -j$(nproc)
make install

# remove sources
cd /
rm -rf /usr/src/python

# install pip, setuptools and virtualenv
/opt/stackless/bin/pip3 install --upgrade pip
/opt/stackless/bin/pip --no-cache-dir install --upgrade setuptools virtualenv

# remove build dependencies for a lighter Docker image
apt-get purge -y --auto-remove $BUILD_DEPS
