FROM debian:jessie

# install stackless in /opt/stackless
RUN deps='ca-certificates libbz2-1.0 libgdbm3 libreadline6 libsqlite3-0 libssl1.0.0 zlib1g'; \
    set -x \
    && apt-get update \
    && apt-get install -y $deps --no-install-recommends

RUN BUILD_DEPS='bzip2 curl gcc libbz2-dev libgdbm-dev libc6-dev libreadline6-dev libsqlite3-dev libssl-dev make zlib1g-dev'; \
    set -x \
 && apt-get update \
 && apt-get install -y $BUILD_DEPS --no-install-recommends
 && mkdir -p /usr/src/python \
 && curl -Ls https://github.com/stackless-dev/stackless/archive/v3.5.6-slp.tar.gz | tar -xzC /usr/src/python --strip-components=1 \
 && cd /usr/src/python \
 && ./configure --prefix=/opt/stackless \
 && make -j$(nproc) \
 && make install \
 && cd / \
 && rm -rf /usr/src/python \
 && /opt/stackless/bin/pip3 install --upgrade pip \
 && /opt/stackless/bin/pip --no-cache-dir install --upgrade setuptools virtualenv \
 && apt-get purge -y --auto-remove $BUILD_DEPS
