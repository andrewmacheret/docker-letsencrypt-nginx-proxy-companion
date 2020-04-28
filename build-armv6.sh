#!/usr/bin/env bash
set -e

docker build -t andrewmacheret/docker-letsencrypt-nginx-proxy-companion:armv6 -f Dockerfile .

docker push andrewmacheret/docker-letsencrypt-nginx-proxy-companion:armv6

