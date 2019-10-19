#!/bin/bash

echo "Starting..."
cd /app

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`
mkdir results
mkdir results/$dirname
mkdir results/$dirname/npb
echo "Saving results to results/$dirname"

# NPB 
echo "Starting NPB..."
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "npb", "npb": { "run_instance": '"$today"', "status": 0 }}'
for file in NPB3.3.1/NPB3.3-OMP/bin/*
do
    echo "Starting $(basename $file)"
    #touch /app/results/$dirname/$(basename $file.result.out
    ./$file > /app/results/$dirname/npb/$(basename $file).result.out
    cat /app/results/$dirname/npb/$(basename $file).result.out
done
python3 npb-parse.py ./results/$dirname/npb http://10.0.0.175:30099/telegraf $today $hn
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "npb", "npb": { "run_instance": '"$today"', "status": 1 }}'
echo "Done."
echo "Saving results to /app/$dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz /app/results/$dirname
echo "Done"