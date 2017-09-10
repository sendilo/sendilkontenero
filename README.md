# sendilkontenero

docker file and composer for sendilo

## contains

 * docker-compose.yml with [haproxy](https://hub.docker.com/r/_/haproxy/) and certbot (Let's Encrypt) scripts
 * [sendilo](https://github.com/sendilo/sendilo) - [node-solid-server](https://github.com/solid/node-solid-server) `release/v4.0.0` with [http-rdf-formats-proxy](https://github.com/rdf-ext/http-rdf-formats-proxy) and [EyeServer](https://github.com/RubenVerborgh/EyeServer) (incl. [EYE reasoner](http://eulersharp.sourceforge.net/)) middlewares

## usage

 * copy content of config.examples to config folder and change the files to reflect your settings
 * run with `docker-compose up -d`

## todo

 * fix eyeserver.js (or better PR EyeServer to work with express 4.x and as its middleware)
 * compile EYE in a separate docker
