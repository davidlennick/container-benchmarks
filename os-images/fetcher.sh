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


red_print "Downloading and unzipping balenaOS img"

mkdir balenaOS-2.38.0-rev1-dev
cd balenaOS-2.38.0-rev1-dev

wget https://files.resin.io/resinos/raspberrypi3/2.38.0%2Brev1.dev/image/balena.img.zip
unzip balena.img.zip
cd ..


red_print "Downloading and unzipping hypriotOS img"

mkdir hypriotOS-rpi-v1.11.1
cd hypriotOS-rpi-v1.11.1

wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.11.1/hypriotos-rpi-v1.11.1.img.zip
unzip hypriotos-rpi-v1.11.1.img.zip
cd ..


red_print "Downloading and unzipping rancherOS img"

mkdir rancherOS-1.5.3
cd rancherOS-1.5.3

wget https://github.com/rancher/os/releases/download/v1.5.3/rancheros-raspberry-pi64.zip
unzip rancheros-raspberry-pi64.zip
cd ..

red_print "########################################################\n \
Use balena-etcher to burn balenaOS, hypriotOS, and rancherOS\n
balenaOS: \t ssh root@<IP> -p 22222 \n
hypriotOS: \t ssh pirate@<IP> \t # password: hypriot \n
rancherOS: \t ssh rancher@<IP> \t # password: rancher"