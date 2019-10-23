#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

red_print () {
    echo -e "\n\n${RED}$1\n########################################################${NC}\n\n"
}

while :
do
  red_print "STOPPING CONTAINERS IF THEY EXIST!\n\
  They should already be stopped...\n\
  If anything comes back, increase sleep time.\n\
  $(date +%Y%m%d%H%M%S)"
  ./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca stream
  ./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca iozone
  ./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca npb
  ./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca bucketbench
  ./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca sysbench
  
  red_print "Starting Telegraf Client : $(date +%Y%m%d%H%M%S)"
  ./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca telegraf-client
  red_print "########################################################\nSleeping 60s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 30

  red_print "Starting STREAM Benchmark: $(date +%Y%m%d%H%M%S)"
  ./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca stream
  red_print "########################################################\nSleeping 60s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 60

  red_print "Starting iozone Benchmark: $(date +%Y%m%d%H%M%S)"
  ./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca iozone
  red_print "########################################################\nSleeping 120s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 120

  red_print "Starting NPB: $(date +%Y%m%d%H%M%S)"
  ./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca npb
  red_print "########################################################\nSleeping 2000s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 2000

  red_print "Starting sysbench: $(date +%Y%m%d%H%M%S)"
  ./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca sysbench
  red_print "########################################################\nSleeping 240s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 240

  red_print "Starting Bucketbench: $(date +%Y%m%d%H%M%S)"
  ./deploy-bucketbench.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.lennick.ca
  red_print "########################################################\nSleeping 960s to let benchmarks finish: $(date +%Y%m%d%H%M%S)"
  sleep 960

done