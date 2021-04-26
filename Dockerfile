# stage 1: builder

FROM debian:buster as builder

# install needed build libraries

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    curl \
    gcc \
    libbz2-dev \
    libgdbm-dev \
    libc6-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    make \
    zlib1g-dev

# build stackless

RUN mkdir -p /usr/src/python \
 && curl -Ls https://github.com/stackless-dev/stackless/archive/v2.7.18-slp.tar.gz | tar -xzC /usr/src/python --strip-components=1 \
 && cd /usr/src/python \
 && ./configure --prefix=/opt/stackless \
 && make -j$(nproc) \
 && make install \
 && /opt/stackless/bin/python -m ensurepip \
 && /opt/stackless/bin/pip install --upgrade pip setuptools virtualenv


# stage 2: the grand finale

FROM debian:buster

# install needed runtime libraries

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    libgdbm6 \
    libreadline7 \
    libsqlite3-0 \
    libssl1.1 \
    xz-utils \
    zlib1g

# get stackless from builder stage

COPY --from=builder /opt/stackless /opt/stackless
