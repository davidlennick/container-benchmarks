#!/bin/bash

sudo -S bash -c 'cat > /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["10.0.0.175:32000"]
}
EOF'

sudo systemctl daemon-reload
sudo systemctl restart docker
