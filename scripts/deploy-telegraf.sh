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

cd balenaOS
ssh -oStrictHostKeyChecking=no -p 22222 root@$1 'balena kill main_1_1'
balena push $1 -c -d --dockerfile ./telegraf.Dockerfile

cd ../
sshpass -phypriot scp ./balenaOS/telegraf.conf pirate@$2:~/
sshpass -prancher scp ./balenaOS/telegraf.conf rancher@$3:~/
sshpass -praspberry scp ./balenaOS/telegraf.conf pi@$4:~/

sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 'bash -s' < ./common/basic-telegraf.sh => logs/hypriot-telegraf.log
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'bash -s' < ./common/basic-telegraf.sh => logs/rancher-telegraf.log
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 'bash -s' < ./common/basic-telegraf.sh => logs/raspbian-telegraf.log
