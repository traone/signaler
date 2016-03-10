# Signaler
[![onnimonni/signaler docker image](http://dockeri.co/image/onnimonni/signaler)](https://registry.hub.docker.com/u/onnimonni/signaler/)

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

Docker container for automatic ssl certificates. Use this in development environment to test **https** connections in local deveplopment. [jwilder/docker-gen](This uses https://github.com/jwilder/docker-gen) to read configs of new containers. This works well with [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy).

This helps you to notice mixed content errors in development and avoid problems when your production is configured to use https connections.

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


## How to add self-generated ca.key as trusted root (for dummies including me)
Sometimes the software you are using won't work correctly if the certificate is not trusted. Sometimes you want to do this just because it's convenient. Usually self-generated certificates will look like this:

![non-trusted https](https://cloud.githubusercontent.com/assets/5691777/13670188/1b042b48-e6d1-11e5-804e-542781b85ff5.png)

If you want to trust these self-generated certificates so that your browser and other tooling (like curl) will accept them you can add the certificate in your trusted certificates. Then it will look like this instead:

![self trusted https](https://cloud.githubusercontent.com/assets/5691777/13670189/1d697032-e6d1-11e5-99b5-aef757cb7f53.png)

**NOTICE: This will open a small attack vector against your machine where MITM can succesfully deceive any of your https connections. Do not give your self-generated ca.key to anyone else!**

### Trust certificates in OS-X
First mount the `/data/ca/ca.key` path from container to your machine for example `~/ca/ca.crt`.
```
$ sudo security add-trusted-cert -d -r trustRoot -k '/Library/Keychains/System.keychain' ~/ca/ca.crt
```

### Trust certificates in Linux (Ubuntu)
First mount the `/data/ca/ca.key` path from container to your machine for example `~/ca/ca.crt`.
```
sudo cp ~/ca/ca.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates
```

## HTTPS for all virtual hosts
Set ```HTTPS_ALL_HOSTS=1``` to generate certificates for all comma separated domains in ```VIRTUAL_HOST``` variable.

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

## License
MIT
