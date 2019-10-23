#!/bin/bash

today=`date +%Y%m%d%H%M%S`
dirname=results-$today
hn=`hostname`

mkdir -p results/$dirname/sysbench
mkdir results/$dirname/sysbench/cpu
#mkdir results/$dirname/sysbench/fileio
mkdir results/$dirname/sysbench/memory
echo "Saving results to results/$dirname"


THREADS=4
RAM_TOTAL_TEST_MB=1024
#FILE_SIZE_GB=2

curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "sysbench", "sysbench": { "run_instance": '"$today"', "status": 0 }}'
for (( i = 1; i <= $THREADS; i++)); do
  sysbench cpu --cpu-max-prime=20000 --threads=$i run >> results/$dirname/sysbench/cpu/cpu-threads_$i.out
  cat results/$dirname/sysbench/cpu/cpu-threads_$i.out
done

for blk_size in 1 32 128 256 512
do
  for oper in read write; do
    for access in seq rnd; do
      sysbench memory \
        --memory-block-size=${blk_size}K \
        --memory-total-size=${RAM_TOTAL_TEST_MB}M \
        --memory-oper=${oper} \
        --memory-access-mode=${access} \
        run >> results/$dirname/sysbench/memory/memory-${blk_size}K-${RAM_TOTAL_TEST_MB}M-${oper}-${access}.out
      cat results/$dirname/sysbench/memory/memory-${blk_size}K-${RAM_TOTAL_TEST_MB}M-${oper}-${access}.out
    done
  done
done
python3 sysbench-parse.py ./results/$dirname/sysbench http://10.0.0.175:30099/telegraf $today $hn
curl -i -XPOST "http://10.0.0.175:30099/telegraf" --data-binary '{ "host": "'"$hn"'", "type": "sysbench", "sysbench": { "run_instance": '"$today"', "status": 1 }}'
echo "Saving results to /app/$dirname.tar.gz"
cd /app
tar -czvf $dirname.tar.gz /app/results/$dirname


# for file_num in 1 4 8; do
#   for blk_size in 512 2048 4096; do
#     for mode in seqwr seqrewr seqrd rndrd rndwr rndrw; do
#       echo $file_num $blk_size $mode
#       echo sysbench fileio \
#         --file-num=${file_num} \
#         --file-block-size=${blk_size}B \
#         --file-total-size=${FILE_SIZE_GB}G \
#         --file-test-mode=${mode} \
#         run >> results/$dirname/sysbench/fileio/fileio-${file_num}-${blk_size}K-${FILE_SIZE_GB}G-${mode}.out
#         #cat results/$dirname/sysbench/fileio/fileio-${file_num}-${blk_size}K-${FILE_SIZE_GB}G-${mode}.out
#     done
#   done
# done
