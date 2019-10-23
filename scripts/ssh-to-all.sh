#!/bin/bash

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
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$1"
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$2"
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$3"
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "$4"

gnome-terminal --title="BalenaOS" -e "ssh -oStrictHostKeyChecking=no root@$1 -p 22222"
gnome-terminal --title="HypriotOS" -e "sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2"
gnome-terminal --title="RancherOS" -e "sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3"
gnome-terminal --title="Raspbian" -e "sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4"




