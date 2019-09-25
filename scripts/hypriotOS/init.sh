#!/bin/bash

sudo ip link set wlan0 down

echo "dtoverlay=pi3-disable-wifi" | sudo tee -a /boot/config.txt

sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt

# enable docker TCP socket
sudo mkdir -p /etc/systemd/system/docker.service.d/
sudo bash -c 'cat > /etc/systemd/system/docker.service.d/startup_options.conf <<EOF
# /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock -H tcp://0.0.0.0:2375
EOF'
sudo systemctl daemon-reload
sudo systemctl restart docker.service


