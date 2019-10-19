#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n"
}

if [ -z "$1" ]
  then
    echo "No argument supplied. IP of balenaOS required!"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No argument supplied. IP of hypriotOS required!"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "No argument supplied. IP of rancherOS required!"
    exit 1
fi

if [ -z "$4" ]
  then
    echo "No argument supplied. IP of raspbian-lite required!"
    exit 1
fi

if [ -z "$5" ]
  then
    echo "No argument supplied. Registry required!"
    exit 1
fi

if [ -z "$6" ]
  then
    echo "No argument supplied. Image name required!"
    exit 1
fi

red_print "Stopping $6 on balena"

ssh -oStrictHostKeyChecking=no -p 22222 root@$1 "balena stop $6 || true && \
balena rm $6 || true && \
balena system prune -f"

cd ../../
red_print "Stopping $6 on hypriot"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 "docker stop $6 || true && \
docker rm $6 || true && \
docker system prune -f"

red_print "Stopping $6 on rancher"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 "docker stop $6 || true && \
docker rm $6 || true && \
docker system prune -f"

red_print "Stopping $6 on rasbian"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 "docker stop $6 || true && \
docker rm $6 || true && \
docker system prune -f"