#!/bin/bash

docker run --rm --network=$DOCKER_NETWORK --name=$PROJECT_NAME-redis -d redis
docker run --rm --network=$DOCKER_NETWORK --name=$PROJECT_NAME-pg -e POSTGRES_PASSWORD=password -d postgres:13
sleep 10

REDIS_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $PROJECT_NAME-redis)
PG_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $PROJECT_NAME-pg)

docker buildx build $DOCKER_ARGS  \
    --build-arg SIDEKIQ_CREDS=$SIDEKIQ_CREDS \
    --build-arg DB_ENV_POSTGRESQL_PASS=password \
    --build-arg DB_ENV_POSTGRESQL_USER=postgres \
    --build-arg DB_PORT_5432_TCP_ADDR=$PG_IP \
    --build-arg SESSION_REDIS_HOST=$REDIS_IP \
    --build-arg STORAGE_REDIS_HOST=$REDIS_IP \
    --build-arg DD_API_KEY=$DD_API_KEY \
    .
rc=$?

docker stop $PROJECT_NAME-redis $PROJECT_NAME-pg


if [ $rc -ne 0 ]; then
  echo -e "Docker build failed"
  exit $rc
fi
