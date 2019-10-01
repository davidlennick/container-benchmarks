#!/bin/bash

sudo ip link set wlan0 down

sudo ros config set rancher.docker.extra_args "['-H','tcp://0.0.0.0:2375','-g','/mnt/docker']"
sudo system-docker restart docker
#sudo ros console switch -f ubuntu

echo "DO THIS!!!!!!!: "
echo "https://rancher.com/docs/os/v1.x/en/installation/running-rancheros/server/raspberry-pi/#using-the-entire-sd-card"
exit