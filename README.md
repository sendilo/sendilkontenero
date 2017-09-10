# sendilkontenero

docker file and composer for sendilo

## contains

 * docker-compose.yml with [haproxy](https://hub.docker.com/r/_/haproxy/) and certbot (Let's Encrypt) scripts
 * [sendilo](https://github.com/sendilo/sendilo) - [node-solid-server](https://github.com/solid/node-solid-server) `release/v4.0.0` with [http-rdf-formats-proxy](https://github.com/rdf-ext/http-rdf-formats-proxy) middleware
 * [EyeServer](https://github.com/RubenVerborgh/EyeServer)

## usage

 * copy content of config.examples to config folder and change the files to reflect your settings
 * run with `docker-compose up -d`

## todo

 * compile EYE in a separate docker or purge the build stack after install
