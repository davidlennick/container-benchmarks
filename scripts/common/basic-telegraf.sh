#!/bin/bash

docker kill telegraf-client
docker system prune -f

docker run --detach \
  --privileged --network=host \
  -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
  -v /:/hostfs:ro -v /run/udev:/run/udev:ro \
  -e HOST_PROC=/hostfs/proc \
  -e HOST_MOUNT_PREFIX=/hostfs \
  --name telegraf-client telegraf