# stage 1

FROM debian:stretch as builder

# install needed libraries

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    bzip2 \
    curl \
    file \
    gcc \
    libbz2-dev \
    libgdbm-dev \
    libc6-dev \
    libffi-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    make \
    zlib1g-dev

RUN mkdir -p /usr/src/python \
 && curl -L https://github.com/stackless-dev/stackless/archive/v3.7.5-slp.tar.gz | tar -xzC /usr/src/python --strip-components=1 \
 && cd /usr/src/python \
 && ./configure --prefix=/opt/stackless \
 && make -j$(nproc) \
 && make install \
 && /opt/stackless/bin/python3 -m ensurepip \
 && /opt/stackless/bin/pip3 --no-cache-dir install --upgrade pip setuptools virtualenv


# stage 2

FROM debian:stretch

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    libffi6 \
    libgdbm3 \
    libreadline7 \
    libsqlite3-0 \
    libssl1.0.2 \
    xz-utils \
    zlib1g

COPY --from=builder /opt/stackless /opt/stackless
