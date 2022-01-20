#!/usr/bin/env sh

VERSION=$(cat version)

docker build -t cr.yandex/crpdedtb1ltgorpuc08s/chatwoot:$VERSION -f docker/Dockerfile .
