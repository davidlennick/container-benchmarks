#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

if [ -z "$1" ]
  then
    echo "No argument supplied. IP of balena required!"
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
    echo "No argument supplied. Username required"
    exit 1
fi

if [ -z "$6" ]
  then
    echo "No argument supplied. Password required"
    exit 1
fi

echo "docker login $7 -u $5 -p $6"

ssh -oStrictHostKeyChecking=no -p 22222 root@$1 "balena login $7 -u $5 -p $6"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 "docker login $7 -u $5 -p $6"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 "docker login $7 -u $5 -p $6"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 "docker login $7 -u $5 -p $6"
