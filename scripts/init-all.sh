#!/bin/bash

# deps for the management console for initializing the differet os envs
# mgmt console is an ubuntu machine

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

sudo -S apt update
sudo -S apt install -y sshpass

mkdir logs
touch logs/balena-info.log
touch logs/hypriot-info.log
touch logs/rancher-info.log
touch logs/raspbian-info.log

#echo $1 $2 $3 $4

ssh root@$1 -p 22222 'bash -s' < get-os-info.sh => logs/balena-info.log
sshpass -phypriot ssh pirate@$2 'bash -s' < get-os-info.sh => logs/hypriot-info.log
sshpass -prancher ssh rancher@$3 'bash -s' < get-os-info.sh => logs/rancher-info.log
sshpass -praspberry ssh pi@$4 'bash -s' < get-os-info.sh => logs/raspbian-info.log


