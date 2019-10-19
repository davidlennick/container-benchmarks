ARG BASE="balenalib/raspberrypi3-debian:buster-build"
FROM ${BASE}

# https://github.com/DaisukeMiyamoto/docker-benchmarks
# https://github.com/kubernetes/kubernetes/tree/master/test/images/node-perf
# https://www.ibm.com/support/knowledgecenter/en/SSWRJV_10.1.0/lsf_admin/EAS_AFS_install_config_benchmark_programs.html

WORKDIR /app
RUN apt -y update
RUN apt install -y gcc g++ make procps build-essential gfortran libgomp1
RUN apt install -y python3 python3-pip && python3 -m pip install requests

# iozone
# http://www.iozone.org/
# https://github.com/pstauffer/docker-iozone

ADD http://www.iozone.org/src/current/iozone3_487.tar .
RUN tar -xf iozone3_487.tar && rm iozone3_487.tar
RUN cd iozone3_487*/src/current && \
    make linux-arm && \
    cd /app && ln -s /app/iozone3_487/src/current/iozone /app/iozone

COPY start.sh .
COPY *.py ./
RUN chmod +x start.sh
CMD /app/start.sh 