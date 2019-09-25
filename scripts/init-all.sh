#!/bin/bash

# deps for the management console for initializing the differet os envs
# mgmt console is an ubuntu machine

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


ssh-keygen -f "/home/$(whoami)/.ssh/known_hosts" -R "$1"
ssh-keygen -f "/home/$(whoami)/.ssh/known_hosts" -R "$2"
ssh-keygen -f "/home/$(whoami)/.ssh/known_hosts" -R "$3"
ssh-keygen -f "/home/$(whoami)/.ssh/known_hosts" -R "$4"


sudo -S apt update
sudo -S apt install -y sshpass

mkdir logs
touch logs/balena-info.log
touch logs/hypriot-info.log
touch logs/rancher-info.log
touch logs/raspbian-info.log

#echo $1 $2 $3 $4

ssh -oStrictHostKeyChecking=no root@$1 -p 22222 'bash -s' < ./common/get-os-info.sh => logs/balena-info.log
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 'bash -s' < ./common/get-os-info.sh => logs/hypriot-info.log
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'bash -s' < ./common/get-os-info.sh => logs/rancher-info.log
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 'bash -s' < ./common/get-os-info.sh => logs/raspbian-info.log


red_print "balenaOS init"
ssh -oStrictHostKeyChecking=no root@$1 -p 22222 'bash -s' < balenaOS/init.sh => logs/balena-init.log
printf "\nDone\n"

red_print "balenaOS reboot and wait"
ssh -oStrictHostKeyChecking=no root@$1 -p 22222 reboot
sleep 2
while true; do ping -c1 $1 > /dev/null && break; done
sleep 4
printf "\nDone\n"


red_print "hypriotOS init"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 'bash -s' < hypriotOS/init.sh => logs/hypriot-init.log
printf "\nDone\n"

red_print "rancherOS init"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'bash -s' < rancherOS/init.sh => logs/rancher-init.log
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'sudo ip link set wlan0 down'

printf "\nDone\n"

red_print "raspbian init"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 'bash -s' < raspbian-lite/init-1.sh => logs/raspbian-init.log
printf "\nDone\n"

red_print "raspbian reboot and wait"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 sudo reboot
sleep 2
while true; do ping -c1 $4 > /dev/null && break; done
printf "\nDone\n"

red_print "raspbian init 2"
sleep 8
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 'bash -s' < raspbian-lite/init-2.sh >> logs/raspbian-init.log


red_print "Done!"