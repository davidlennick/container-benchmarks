ARG BASE="balenalib/raspberrypi3-ubuntu:latest"
FROM ${BASE}

WORKDIR /app
RUN apt update && apt install -y sysbench python3 python3-pip curl
RUN python3 -m pip install requests

COPY *.py ./
COPY start.sh .
CMD ./start.sh