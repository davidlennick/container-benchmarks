ARG BASE="balenalib/raspberrypi3-debian:buster-build"
FROM ${BASE}

WORKDIR /app
RUN apt -y update
RUN apt install -y gcc g++ make procps build-essential gfortran libgomp1
RUN apt install -y python3 python3-pip && python3 -m pip install requests

ADD https://www.cs.virginia.edu/stream/FTP/Code/stream.c .
RUN MB=$(free | grep Mem | tr -s ' ' | cut -d ' ' -f 4) && \
    ARRAYSIZE=$(( $MB * 40 )) && \
    gcc -fstrict-aliasing -fopenmp -Ofast -march=armv8-a -mfloat-abi=hard -mfpu=neon-fp-armv8 \ 
    ./stream.c \
    -DSTREAM_ARRAY_SIZE=$ARRAYSIZE \
    -o stream-gcc 

COPY *.py ./
COPY start.sh .
CMD /app/start.sh 