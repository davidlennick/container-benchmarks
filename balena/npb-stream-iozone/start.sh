#!/bin/bash

cd /app

today=`date +%Y-%m-%d.%H:%M:%S`
dirname=results-$today
mkdir results
mkdir results/$dirname


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

# 10MiB file, 8kb record size
./iozone -i 0 -i 1 -s 10240 -r 8 -t $OMP_NUM_THREADS > results/$dirname/iozone-10mb-8kb.out

# 100MiB file, 32kB record size
./iozone -i 0 -i 1 -s 102400 -r 32 -t $OMP_NUM_THREADS > results/$dirname/iozone-100mb-32kb.out


# stream benchmark
./stream-gcc > results/$dirname/stream.out


# NPB 
for file in NPB3.3.1/NPB3.3-OMP/bin/*
do
  ./$file > results/$dirname/$file.out
done