#!/bin/bash

# Warn if the DOCKER_HOST socket does not exist
if [[ $DOCKER_HOST == unix://* ]]; then
  socket_file=${DOCKER_HOST#unix://}
  if ! [ -S $socket_file ]; then
    echo "ERROR: you need to share your Docker host socket with a volume at $socket_file"
    echo "Typically you should run your onnimonni/signaler with: \`-v /var/run/docker.sock:$socket_file:ro\`"
    echo "See the documentation at http://github.com/onnimonni/signaler"
    socketMissing=1
  fi
fi

# If the user has run the default command and the socket doesn't exist, fail
if [ "$socketMissing" = 1 -a "$1" = forego -a "$2" = start -a "$3" = '-r' ]; then
  exit 1
fi

if [ -d $CA_FOLDER ]; then
  mkdir -p $CA_FOLDER
fi

if [ -d $CERTS_FOLDER ]; then
  mkdir -p $CERT_FOLDER
fi

# Generate CA certificate if not exists
/app/bin/generate-ssl-ca

# Start jwilder/docker-gen
docker-gen -config /etc/docker-gen/docker-gen.cfg