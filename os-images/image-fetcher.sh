#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

red_print "Installing deps"

sudo -S apt install unzip
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
sudo -S apt update
sudo -S apt install balena-etcher-electron


red_print "Downloading balenaOS img"

mkdir balenaOS-2.43.0-rev1-dev
cd balenaOS-2.43.0-rev1-dev
wget https://files.resin.io/resinos/raspberrypi3/2.43.0%2Brev1.dev/image/balena.img.zip
cd ..


red_print "Downloading hypriotOS img"

mkdir hypriotOS-rpi-v1.11.2
cd hypriotOS-rpi-v1.11.2
wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.11.2/hypriotos-rpi-v1.11.2.img.zip
cd ..


red_print "Downloading rancherOS img"

mkdir rancherOS-1.5.4
cd rancherOS-1.5.4
wget https://github.com/rancher/os/releases/download/v1.5.4/rancheros-raspberry-pi64.zip
cd ..


red_print "Downloading raspbian lite img"

mkdir raspbian-buster-lite-2019-07-10
cd raspbian-buster-lite-2019-07-10
wget http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-07-12/2019-07-10-raspbian-buster-lite.zip
cd ..


red_print "########################################################\n\
Use balena-etcher to burn balenaOS, hypriotOS, rancherOS, and raspbian lite \n
For raspbian-lite, add an empty file called \"ssh\" to the boot partition (or run raspbian-prep.sh) \n
rasbian: \t ssh pi@<IP> \t\t # password: raspberry \n 
balenaOS: \t ssh root@<IP> -p 22222 \t# no password \n 
hypriotOS: \t ssh pirate@<IP> \t # password: hypriot \n
rancherOS: \t ssh rancher@<IP> \t # password: rancher"