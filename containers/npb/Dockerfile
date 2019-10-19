ARG BASE="balenalib/raspberrypi3-debian:buster-build"
FROM ${BASE}

WORKDIR /app
RUN apt -y update
RUN apt install -y gcc g++ make procps build-essential gfortran libgomp1
RUN apt install -y python3 python3-pip && python3 -m pip install requests

# NAS Parallel benchmark
# https://www.nas.nasa.gov/publications/npb.html

RUN export OMP_NUM_THREADS=$(nproc) && \
    export GOMP_CPU_AFFINITY="0-$(($OMP_NUM_THREADS - 1))"

ADD https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz .
RUN tar -xzf NPB3.3.1.tar.gz && rm NPB3.3.1.tar.gz
COPY npb/config/ NPB3.3.1/NPB3.3-OMP/config/
RUN cd NPB3.3.1/NPB3.3-OMP && make suite 
RUN cd NPB3.3.1/NPB3.3-OMP && sed -i 's/S/A/g' ./config/suite.def && make suite 

COPY *.py ./
COPY start.sh .
RUN chmod +x start.sh
CMD /app/start.sh 