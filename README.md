# sendilkontenero

docker file and composer for sendilo

## contains

 * docker-compose.yml with [haproxy](https://hub.docker.com/r/_/haproxy/) and certbot (Let's Encrypt) scripts
 * [sendilo](https://github.com/sendilo/sendilo) - container with [node-solid-server](https://github.com/solid/node-solid-server) and [http-rdf-formats-proxy](https://github.com/rdf-ext/http-rdf-formats-proxy) middleware
 * [EyeServer](https://github.com/RubenVerborgh/EyeServer) in a separate container

## usage

 * copy content of config.examples to config folder and change the files to reflect your settings
 * run with `docker-compose up -d`
