# sendilkontenero

docker file and composer for sendilo

## contains

 * docker-compose.yml with nginx proxy and let's encrypt companion
 * sendilo - node-solid-server with http-rdf-formats-proxy and EyeServer (incl. EYE reasoner) middlewares

## usage

 * copy `example.env` to `.env` and `example.config.json` to `config.json` and change its content to reflect your settings
 * run with `docker-compose up -d`

## todo

 * fix eyeserver.js (better PR EyeServer to work with express 4.x and as its middleware)
 * compile EYE in a separate docker
 * test let's encrypt cert creation and renewal
