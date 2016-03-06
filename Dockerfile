FROM jwilder/docker-gen
MAINTAINER Onni Hakala - Geniem Oy. <onni.hakala@geniem.com>

# Install openssl for signing certificates
RUN apt-get update && apt-get install openssl

# Set some default parameters
ENV GENERATOR="self-signed"