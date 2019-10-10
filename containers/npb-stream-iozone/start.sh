#!/bin/bash

echo "Starting..."
cd /app

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`
mkdir results
mkdir results/$dirname
mkdir results/$dirname/iozone
mkdir results/$dirname/npb
mkdir results/$dirname/stream
echo "Saving results to results/$dirname"

# iozone benchmark
# The test-type is a numeric value. The following are the various available test types and its numeric value.
#     0=write/rewrite
#     1=read/re-read
#     2=random-read/write
#     3=Read-backwards
#     4=Re-write-record
#     5=stride-read
#     6=fwrite/re-fwrite
#     7=fread/Re-fread,
#     8=random mix
#     9=pwrite/Re-pwrite
#     10=pread/Re-pread
#     11=pwritev/Re-pwritev
#     12=preadv/Re-preadv

echo "Starting iozone..."
# 10MiB file, 8kb record size
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "iozone", "iozone": { "10240": { "8": { "run_instance": '"$today"', "status": 0, }}}}'
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


# stream benchmark
echo "Starting stream-gcc..."
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "stream", "stream": { "run_instance": '"$today"', "status": 0 }}'
./stream-gcc > results/$dirname/stream/stream.out
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "stream", "stream": { "run_instance": '"$today"', "status": 1 }}'
python3 stream-parse.py ./results/$dirname/stream http://10.0.0.175:30099/telegraf $today $hn
cat results/$dirname/stream/stream.out
echo "Done."


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