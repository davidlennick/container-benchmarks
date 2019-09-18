#!/bin/bash

rfkill block bluetooth
sudo systemctl stop bluetooth.service
sudo systemctl disable bluetooth.service
