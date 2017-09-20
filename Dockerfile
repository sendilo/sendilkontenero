FROM node:slim

RUN mkdir -p /solid/certs /solid/data /solid/db /solid/run/ \
 && cd /solid/run \
 && npm view sendilo dist.tarball | xargs curl | tar -xz package/ --strip-components=1 \
 && npm install

WORKDIR /solid/run/

VOLUME /solid/certs /solid/data /solid/db

CMD ["/solid/run/bin/sendilo", "start", "--verbose"]
