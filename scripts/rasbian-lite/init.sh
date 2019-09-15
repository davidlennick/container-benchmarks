#!/bin/bash

sudo -S apt update 
sudo -S apt -y dist-upgrade 
sudo -S apt -y install apt-transport-https ca-certificates software-properties-common
curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
sudo usermod -aG docker pi

sudo ip link set wlan0 down
rfkill block wifi
rfkill block bluetooth

sudo reboot
