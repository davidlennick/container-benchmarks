#!/bin/bash

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`
mkdir results
mkdir results/$dirname
mkdir results/$dirname/bucketbench
echo "Saving results to results/$dirname"

echo "Starting bucketbench..."
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "bucketbench", "bucketbench": { "run_instance": '"$today"', "status": 0 }}'

bucketbench run -b bb-run-stop.yaml --overhead --log-level debug >> results/$dirname/bucketbench/bb-run-stop.out
cat results/$dirname/bucketbench/bb-run-stop.out

bucketbench run -b bb-run-stop-stress.yaml --skip-limit --overhead --log-level debug >> results/$dirname/bucketbench/bb-run-stop-stress.out
cat results/$dirname/bucketbench/bb-run-stop-stress.out

# bucketbench run -b bb-pause-stress.yaml --skip-limit --overhead --log-level debug >> results/$dirname/bucketbench/bb-pause-stress.out
# cat results/$dirname/bucketbench/bb-pause-stress.out

curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "bucketbench", "bucketbench": { "run_instance": '"$today"', "status": 1 }}'
python3 bucketbench-parse.py ./results/$dirname/bucketbench http://10.0.0.175:30099/telegraf $today $hn

echo "Done."
echo "Saving results to $dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz results/$dirname
echo "Done"
