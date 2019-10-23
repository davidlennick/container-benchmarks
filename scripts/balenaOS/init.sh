#!/bin/bash

ip link set wlan0 down
nmcli radio wifi off
echo "dtoverlay=pi3-disable-wifi" | tee -a /boot/config.txt

nmcli radio wifi off
echo "dtoverlay=pi3-disable-bt" | tee -a /boot/config.txt

exit

