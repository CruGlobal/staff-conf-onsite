#!/bin/bash

docker buildx build $DOCKER_ARGS  \
    --build-arg SIDEKIQ_CREDS=$SIDEKIQ_CREDS \
    .
rc=$?

if [ $rc -ne 0 ]; then
  echo -e "Docker build failed"
  exit $rc
fi
