#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
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




sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'bash -s' < rancherOS/insecure-registry.sh => logs/rancher-registry.log
