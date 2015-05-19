FROM debian:jessie

RUN set -x \
    && apt-get update \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

# install stackless in /opt/stackless
RUN deps='ca-certificates libbz2-1.0 libgdbm3 libreadline6 libsqlite3-0 libssl1.0.0 zlib1g'; \
    set -x \
    && apt-get update \
    && apt-get install -y $deps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN buildDeps='curl gcc libbz2-dev libgdbm-dev libc6-dev libreadline6-dev libsqlite3-dev libssl-dev make xz-utils zlib1g-dev'; \
    set -x \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src/python \
    && curl http://www.stackless.com/binaries/stackless-342-export.tar.xz | tar -xJC /usr/src/python --strip-components=1 \
    && cd /usr/src/python \
    && ./configure --prefix=/opt/stackless \
    && make -j$(nproc) \
    && make install \
    && cd / \
    && rm -rf /usr/src/python \
    && /opt/stackless/bin/pip3 install --upgrade pip \
    && /opt/stackless/bin/pip --no-cache-dir install --upgrade setuptools virtualenv \
    && apt-get purge -y --auto-remove $buildDeps
