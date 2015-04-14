FROM buildpack-deps:wheezy

ADD http://www.stackless.com/binaries/stackless-342-export.tar.xz /

# remove several traces of debian python
RUN apt-get purge -y 'python.*'

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYTHON_VERSION 3.4.2

RUN set -x \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f /stackless-342-export.tar.xz \
	&& rm /stackless-342-export.tar.xz \
	&& cd /usr/src/python \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
        && pip3 install virtualenv \
	&& rm -rf /usr/src/python

CMD ["python3"]
