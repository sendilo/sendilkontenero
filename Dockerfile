FROM node:slim

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
ENV RELEASE=EYE-Autumn16

RUN apt-get -qq update \
 && `# Install dependencies:` apt-get -qqy --no-install-recommends install \
    jq curl unzip libarchive13 libgmp-dev libgmp10 ca-certificates \
    build-essential autoconf curl chrpath pkg-config ncurses-dev libreadline-dev \
    libedit-dev libunwind-dev libgmp-dev libssl-dev unixodbc-dev zlib1g-dev libarchive-dev \
    libossp-uuid-dev libxext-dev libice-dev libjpeg-dev libxinerama-dev libxft-dev \
    libxpm-dev libxt-dev libdb-dev libpcre3-dev flex \
    libgdbm3 libsqlite3-0 libssl1.0.0 \
    git \
 && `# remove unnescesary files` apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/debconf/*

ENV GPG_KEY C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
ENV PYTHON_VERSION 2.7.13

RUN set -ex \
	&& buildDeps=' \
		dpkg-dev \
		gcc \
		libbz2-dev \
		libc6-dev \
		libdb-dev \
		libgdbm-dev \
		libncurses-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		make \
		tcl-dev \
		tk-dev \
		wget \
		xz-utils \
		zlib1g-dev \
	' \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
	\
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-shared \
		--enable-unicode=ucs4 \
	&& make -j "$(nproc)" \
	&& make install \
	&& ldconfig \
	\
#	&& apt-get purge -y --auto-remove $buildDeps \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf /usr/src/python

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 9.0.1

RUN set -ex; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends wget; \
	rm -rf /var/lib/apt/lists/*; \
	\
	wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py'; \
	\
	apt-get purge -y --auto-remove wget; \
	\
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==$PYTHON_PIP_VERSION" \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py


RUN curl -fsS -O http://www.swi-prolog.org/download/stable/src/swipl-7.4.2.tar.gz \
 && tar xvzf swipl-7.4.2.tar.gz \
 && rm swipl-7.4.2.tar.gz
RUN cd swipl-7.4.2 \
 && cat build.templ \
    | sed 's/^PREFIX=\$HOME$/PREFIX=\/usr\/local/' \
    > build \
 && chmod +x ./build
RUN cd swipl-7.4.2 && ./build
RUN rm -rf swipl-7.4.2

RUN mkdir eye \
 && cd eye \
 && `#curl -fsS -L -O "http://downloads.sourceforge.net/project/eulersharp/eulersharp/"$RELEASE"/eye.zip"` \
 && `#curl -fsS -L -o eye.json "https://sourceforge.net/projects/eulersharp/files/eulersharp/"$RELEASE"/eye.zip/list"` \
 && `#echo $( jq -r '.["eye.zip"]|.sha1' eye.json ) " eye.zip" | sha1sum -c -` \
 && curl -fsS -L -O "https://raw.githubusercontent.com/josd/eye/master/eye.zip" \
 && unzip eye \
 && ./eye/install.sh \
 && rm -rf eye \
 && ln -s /opt/eye/bin/eye.sh /usr/local/bin/eye

RUN curl -fsS -o cturtle-1.0.5.tar.gz https://codeload.github.com/melgi/cturtle/tar.gz/v1.0.5 \
 && tar xvzf cturtle-1.0.5.tar.gz \
 && rm cturtle-1.0.5.tar.gz \
 && cd cturtle-1.0.5 \
 && make install

RUN mkdir -p /solid/certs /solid/data /solid/db /solid/run/ \
 && cd /solid \
 && echo 'clone sendilo' \
 && git clone -b 'master' https://github.com/sendilo/sendilo run \
 && cd /solid/run \
 && npm install

WORKDIR /solid/run/

VOLUME /solid/certs /solid/data /solid/db
CMD ["/solid/run/bin/sendilo", "start", "--verbose"]
