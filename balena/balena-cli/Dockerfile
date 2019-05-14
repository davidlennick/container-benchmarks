FROM node:8

ENV BALENAOS_IP="127.0.0.1"
VOLUME ["/data"]

RUN npm install balena-cli -g --production --unsafe-perm
RUN cd /data && DEBUG=1 balena push ${BALENAOS_IP}  