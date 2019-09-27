#!/bin/bash

sudo ip link set wlan0 down

sudo ros config set rancher.docker.extra_args "['-H','tcp://0.0.0.0:2375']"
sudo system-docker restart docker
#sudo ros console switch -f ubuntu
exit