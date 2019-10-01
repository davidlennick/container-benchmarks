#!/bin/bash

echo "Starting..."
cd /app

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
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
./iozone -i 0 -i 1 -s 10240 -r 8 -t $(nproc) > results/$dirname/iozone/iozone-10mb-8kb.out

# 100MiB file, 32kB record size
./iozone -i 0 -i 1 -s 102400 -r 32 -t $(nproc) > results/$dirname/iozone/iozone-100mb-32kb.out
cat results/$dirname/iozone/iozone-10mb-8kb.out
cat results/$dirname/iozone/iozone-100mb-32kb.out

echo "Done."


echo "Starting stream-gcc..."
# stream benchmark
./stream-gcc > results/$dirname/stream/stream.out
cat results/$dirname/stream/stream.out
echo "Done."


# NPB 
echo "Starting NPB..."
for file in NPB3.3.1/NPB3.3-OMP/bin/*
do
    echo "Starting $(basename $file)"
    #touch /app/results/$dirname/$(basename $file.result.out
    ./$file > /app/results/$dirname/npb/$(basename $file).result.out
    cat /app/results/$dirname/npb/$(basename $file).result.out
done

echo "Saving results to /app/$dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz /app/results/$dirname
echo "Done"