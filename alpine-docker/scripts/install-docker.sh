#!/bin/sh

echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk update --quiet
apk add --quiet docker
rc-update add docker boot
