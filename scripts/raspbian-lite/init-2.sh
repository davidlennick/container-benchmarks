#!/bin/bash

rfkill block bluetooth
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service

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

