FROM debian:jessie

# install stackless in /opt/stackless
RUN deps='ca-certificates libbz2-1.0 libgdbm3 libreadline6 libsqlite3-0 libssl1.0.0 zlib1g'; \
    set -x \
    && apt-get update \
    && apt-get install -y $deps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY /build.sh /
RUN sh -x /build.sh && rm /build.sh
