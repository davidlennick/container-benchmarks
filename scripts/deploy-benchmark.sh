#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

if [ -z "$1" ]
  then
    echo "No argument supplied. IP of balenaOS required!"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No argument supplied. IP of hypriotOS required!"
    exit 1
fi

if [ -z "$3" ]
  then
    echo "No argument supplied. IP of rancherOS required!"
    exit 1
fi

if [ -z "$4" ]
  then
    echo "No argument supplied. IP of raspbian-lite required!"
    exit 1
fi

red_print "Deploying to balena"
cd ../npb-stream-iozone
#ssh -oStrictHostKeyChecking=no -p 22222 root@$1 'balena stop main_1_1 || true && balena rm main_1_1 || true && balena system prune -f'
DEBUG=1 balena push $1 -d --nolive .

red_print "Copying files to remote OSs"
cd ../
sshpass -phypriot scp -r ./npb-stream-iozone pirate@$2:~/
sshpass -prancher scp -r ./npb-stream-iozone rancher@$3:~/
sshpass -praspberry scp -r ./npb-stream-iozone pi@$4:~/

cd scripts
red_print "Deploying to hypriot"
sshpass -phypriot ssh -oStrictHostKeyChecking=no pirate@$2 'bash -s' < ./common/basic-benchmark.sh => logs/hypriot-benchmark.log

red_print "Deploying to rancher"
sshpass -prancher ssh -oStrictHostKeyChecking=no rancher@$3 'bash -s' < ./common/basic-benchmark.sh => logs/rancher-benchmark.log

red_print "Deploying to rasbian"
sshpass -praspberry ssh -oStrictHostKeyChecking=no pi@$4 'bash -s' < ./common/basic-benchmark.sh => logs/raspbian-benchmark.log

red_print "If there are problems, check logs/<OS>-benchmark.log for information"