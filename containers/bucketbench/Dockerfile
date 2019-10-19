ARG BASE="golang:buster"
FROM ${BASE}

WORKDIR /app
RUN go get github.com/estesp/bucketbench
RUN cd $GOPATH/src/github.com/estesp/bucketbench && make && make install

RUN apt update
RUN apt install -y python3 python3-pip 
RUN python3 -m pip install requests

RUN apt install curl

COPY start.sh ./
COPY ./bb* /app/
COPY ./bucketbench* /app/
#CMD bucketbench run -b /app/bench-run.yaml
CMD ./start.sh