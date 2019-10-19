#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n"
}

if [ -z "$1" ]; then
    echo "No argument supplied. IP of balenaOS required!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No argument supplied. IP of hypriotOS required!"
    exit 1
fi

if [ -z "$3" ]; then
    echo "No argument supplied. IP of rancherOS required!"
    exit 1
fi

if [ -z "$4" ]; then
    echo "No argument supplied. IP of raspbian-lite required!"
    exit 1
fi

if [ -z "$5" ]; then
    echo "No argument supplied. Registry required!"
    exit 1
fi

CONTAINER_NAME="bucketbench"
BALENA_ARGS="--privileged --network=host \
  -v /var/run/balena.sock:/var/run/docker.sock \
  -v /usr/bin/balena:/usr/bin/docker \
  -v /usr/bin/balenad:/usr/bin/dockerd \
  -v /var/run/balena:/var/run/docker \
  -v /var/run/docker.pid:/var/run/docker.pid \
  -v /proc:/proc"
DOCKER_ARGS="--privileged --network=host \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /usr/bin/dockerd:/usr/bin/dockerd \
  -v /var/run/docker:/var/run/docker \
  -v /var/run/docker.pid:/var/run/docker.pid \
  -v /proc:/proc"

red_print "Deploying to balena"
ssh -oStrictHostKeyChecking=no -p 22222 root@$1 "balena stop $CONTAINER_NAME || true && \
balena rm $CONTAINER_NAME || true && \
balena pull $5/$CONTAINER_NAME:arm && \
balena run -d $BALENA_ARGS --name $CONTAINER_NAME $5/$CONTAINER_NAME:arm"

cd ../../
red_print "Deploying to hypriot"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 "docker stop $CONTAINER_NAME || true && \
docker rm $CONTAINER_NAME || true && \
docker pull $5/$CONTAINER_NAME:arm && \
docker run -d $DOCKER_ARGS --name $CONTAINER_NAME $5/$CONTAINER_NAME:arm"

red_print "Deploying to rancher"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 "docker stop $CONTAINER_NAME || true && \
docker rm $CONTAINER_NAME || true && \
docker pull $5/$CONTAINER_NAME:arm && \
docker run -d $DOCKER_ARGS --name $CONTAINER_NAME $5/$CONTAINER_NAME:arm"

red_print "Deploying to rasbian"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 "docker stop $CONTAINER_NAME || true && \
docker rm $CONTAINER_NAME || true && \
docker pull $5/$CONTAINER_NAME:arm && \
docker run -d $DOCKER_ARGS --name $CONTAINER_NAME $5/$CONTAINER_NAME:arm"