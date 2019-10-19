#!/bin/bash

echo "Starting..."
cd /app

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`
mkdir results
mkdir results/$dirname
mkdir results/$dirname/iozone
echo "Saving results to results/$dirname"

echo "Starting iozone..."
# 10MiB file, 8kb record size
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "iozone", "iozone": { "10240": { "8": { "run_instance": '"$today"', "status": 0 }}}}'
./iozone -i 0 -i 1 -s 10240 -r 8 -t $(nproc) > results/$dirname/iozone/iozone-10mb-8kb.out
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "iozone", "iozone": { "10240": { "8": { "run_instance": '"$today"', "status": 1 }}}}'

# 100MiB file, 32kB record size
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "iozone", "iozone": { "102400": { "32": { "run_instance": '"$today"', "status": 0 }}}}'
./iozone -i 0 -i 1 -s 102400 -r 32 -t $(nproc) > results/$dirname/iozone/iozone-100mb-32kb.out
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "iozone", "iozone": { "102400": { "32": { "run_instance": '"$today"', "status": 1 }}}}'
cat results/$dirname/iozone/iozone-10mb-8kb.out
cat results/$dirname/iozone/iozone-100mb-32kb.out

python3 iozone-parse.py ./results/$dirname/iozone http://10.0.0.175:30099/telegraf $today $hn

echo "Done."
echo "Saving results to /app/$dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz /app/results/$dirname
echo "Done"