#!/bin/bash

sudo ip link set wlan0 down
rfkill block wifi
rfkill block bluetooth


