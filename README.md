# sendilkontenero

docker file and composer for sendilo

## contains

 * docker-compose.yml with [nginx proxy](https://github.com/jwilder/nginx-proxy) and [let's encrypt companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)
 * [sendilo](https://github.com/sendilo/sendilo) - [node-solid-server](https://github.com/solid/node-solid-server) `release/v4.0.0` with [http-rdf-formats-proxy](https://github.com/rdf-ext/http-rdf-formats-proxy) and [EyeServer](https://github.com/RubenVerborgh/EyeServer) (incl. [EYE reasoner](http://eulersharp.sourceforge.net/)) middlewares

## usage

 * copy `example.env` to `.env` and `example.config.json` to `config.json` and change its content to reflect your settings
 * run with `docker-compose up -d`

## todo

 * fix eyeserver.js (or better PR EyeServer to work with express 4.x and as its middleware)
 * compile EYE in a separate docker
 * test let's encrypt cert creation and renewal
