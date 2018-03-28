#!/bin/bash

set -e


sudo systemctl stop docker-compose-ephemeral@nginx-reverse-proxy.service

. aws-env
docker run \
  -v nginx-certs:/etc/letsencrypt \
  -e http_proxy=$http_proxy \
  -e domains="wiki.mfg.otaya.cc,munin.mfg.otaya.cc,portainer.mfg.otaya.cc" \
  -e email="alert@otaya.cc" \
  -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  -p 80:80 \
  -p 443:443 \
  --rm certbot:latest

sudo systemctl start docker-compose-ephemeral@nginx-reverse-proxy.service
