# Signaler
**THIS IS NOT WORKING YET, WAIT FOR STABLE RELEASE!**

Docker container for automatic ssl certificates. Use this in development environment to test **https** connections in local deveplopment. [jwilder/docker-gen](This uses https://github.com/jwilder/docker-gen) to read configs of new containers. This works well with [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy).

## How to use

Run jwilder/nginx-proxy
```
$ docker run -d -p 80:80 -p 443:443 -v /var/run/docker.sock:/tmp/docker.sock:ro -v /path/to/certs:/etc/nginx/certs jwilder/nginx-proxy
```

Run the signaler container:
```
$ docker run -d -v /path/to/certs:/etc/nginx/certs -v /var/run/docker.sock:/var/run/docker.sock:ro onnimonni/signaler
```

Run any container with `VIRTUAL_HOST` and `HTTPS_HOST`
```
$ docker run -e VIRTUAL_HOST=example.dev -e HTTPS_HOST=example.dev ...
```

Now you can use https://example.dev when connecting to your container.

## HTTPS for all virtual hosts
Set ```HTTPS_ALL_HOSTS=true``` to generate certificates for all comma separated domains in ```VIRTUAL_HOST``` variable.

## Features
- Creates one ca.key and ca.crt which you can optionally add to your trusted keychain.
- Creates one ssl certificate per domain.

## Signaler Environment variables
``` GENERATOR ``` This tells signaler to use different certificate generator for creating certificates. This will hopefully contain **letsencrypt in the future**. Default: `self-signed`

## Building the image in project
```
# Run build command in this project directory
$ docker-compose build
```
