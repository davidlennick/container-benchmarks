#!/bin/bash

sudo ip link set wlan0 down

echo "dtoverlay=pi3-disable-wifi" | sudo tee -a /boot/config.txt


sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt

