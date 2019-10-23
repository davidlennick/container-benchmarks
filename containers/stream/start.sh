#!/bin/bash

echo "Starting..."
cd /app

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`
mkdir results
mkdir results/$dirname
mkdir results/$dirname/stream
echo "Saving results to results/$dirname"

echo "Sleeping to let the system settle..."
sleep 10

# stream benchmark
echo "Starting stream-gcc..."
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "stream", "stream": { "run_instance": '"$today"', "status": 0 }}'
./stream-gcc > results/$dirname/stream/stream.out
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "stream", "stream": { "run_instance": '"$today"', "status": 1 }}'
python3 stream-parse.py ./results/$dirname/stream http://10.0.0.175:30099/telegraf $today $hn
cat results/$dirname/stream/stream.out
echo "Done."

echo "Saving results to /app/$dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz /app/results/$dirname
echo "Done"