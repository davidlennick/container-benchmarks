ARG BASE="balenalib/raspberrypi3-debian:buster"
FROM ${BASE}


# https://github.com/DaisukeMiyamoto/docker-benchmarks
# https://github.com/kubernetes/kubernetes/tree/master/test/images/node-perf
# https://www.ibm.com/support/knowledgecenter/en/SSWRJV_10.1.0/lsf_admin/EAS_AFS_install_config_benchmark_programs.html

WORKDIR /app
RUN apt -y update
RUN apt install -y gcc g++ make build-essential gfortran libgomp1


# iozone
# http://www.iozone.org/
# https://github.com/pstauffer/docker-iozone

ADD http://www.iozone.org/src/current/iozone3_487.tar .
RUN tar -xf iozone3_487.tar && rm iozone3_487.tar
RUN cd iozone3_487*/src/current && \
    make linux && \
    cd /app && ln -s /app/iozone3_487/src/current/iozone /app/iozone


# STREAM
# https://www.cs.virginia.edu/stream/
# https://github.com/hpc-training/docker/blob/master/benchmarks/centos-gcc-stream/run-benchmark.sh

ADD https://www.cs.virginia.edu/stream/FTP/Code/stream.c .
RUN MB=$(free | grep Mem | tr -s ' ' | cut -d ' ' -f 4) && \
    ARRAYSIZE=$(( $MB * 40 )) && \
    gcc -fstrict-aliasing -Ofast -mtune=native -march=native \
    -fopenmp ./stream.c -DSTREAM_ARRAY_SIZE=$ARRAYSIZE \
    -o stream-gcc && \
    export OMP_NUM_THREADS=$(nproc) && \
    export GOMP_CPU_AFFINITY="0-$(($OMP_NUM_THREADS - 1))"


# NAS Parallel benchmark
# https://www.nas.nasa.gov/publications/npb.html

ADD https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz .
RUN tar -xzf NPB3.3.1.tar.gz && rm NPB3.3.1.tar.gz
COPY npb/config/ NPB3.3.1/NPB3.3-OMP/config/
RUN cd NPB3.3.1/NPB3.3-OMP && make suite 
RUN cd NPB3.3.1/NPB3.3-OMP && sed -i 's/S/A/g' ./config/suite.def && make suite 


COPY start.sh .
CMD /app/start.sh 