FROM node:slim

ENV RELEASE=EYE-Autumn16

RUN apt-get -qq update \
 && `# Install dependencies:` apt-get -qqy --no-install-recommends install \
    jq curl unzip libarchive13 libgmp-dev libgmp10 ca-certificates git \
    build-essential autoconf curl chrpath pkg-config ncurses-dev libreadline-dev \
    libedit-dev libunwind-dev libgmp-dev libssl-dev unixodbc-dev zlib1g-dev libarchive-dev \
    libossp-uuid-dev libxext-dev libice-dev libjpeg-dev libxinerama-dev libxft-dev \
    libxpm-dev libxt-dev libdb-dev libpcre3-dev flex \
 && `# remove unnescesary files` apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/debconf/*

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
 && git clone -b 'master' https://github.com/sendilo/sendilo run \
 && cd /solid/run \
 && npm update

WORKDIR /solid/run/

VOLUME /solid/certs /solid/data /solid/db
CMD ["/solid/run/bin/sendilo", "start", "--verbose"]
