FROM buildpack-deps:wheezy

ADD http://www.stackless.com/binaries/stackless-279-export.tar.xz /
ADD https://bootstrap.pypa.io/get-pip.py /

# remove several traces of debian python
RUN apt-get purge -y 'python.*'

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

ENV PYTHON_VERSION 2.7.9

RUN set -x \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f /stackless-279-export.tar.xz \
	&& rm /stackless-279-export.tar.xz \
	&& cd /usr/src/python \
	&& ./configure --enable-shared --enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	&& python2 /get-pip.py \
        && rm /get-pip.py \
	&& find /usr/local \
		\( -type d -a -name test -o -name tests \) \
		-o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		-exec rm -rf '{}' + \
        && pip install virtualenv \
	&& rm -rf /usr/src/python

CMD ["python2"]
