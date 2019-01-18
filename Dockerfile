FROM debian:stable as builder

# install needed libraries

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
 && curl -Ls https://github.com/stackless-dev/stackless/archive/v2.7.15-slp.tar.gz | tar -xzC /usr/src/python --strip-components=1 \
 && cd /usr/src/python \
 && ./configure --prefix=/opt/stackless \
 && make -j$(nproc) \
 && make install \
 && /opt/stackless/bin/python -m ensurepip \
 && /opt/stackless/bin/pip install --upgrade pip setuptools virtualenv


# stage 2

FROM debian:stable

COPY --from=builder /opt/stackless /opt/stackless

# install needed libraries

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    libgdbm3 \
    libreadline7 \
    libsqlite3-0 \
    libssl1.0.2 \
    xz-utils \
    zlib1g
