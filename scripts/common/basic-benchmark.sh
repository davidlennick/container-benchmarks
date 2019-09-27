#!/bin/bash


docker stop benchmark-client || true && docker rm benchmark-client || true
docker system prune -f

cd npb-stream-iozone
mkdir logs
docker build -t bm .

docker run --detach \
  -v $PWD/logs:/app/results \
  --name benchmark-client \
  bm

exit