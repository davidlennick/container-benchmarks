docker build -t bb .

docker run --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /usr/bin/dockerd:/usr/bin/dockerd \
  -v /usr/bin/runc:/usr/bin/runc \
  -v /var/run/docker.pid:/var/run/docker.pid \
  -v /proc:/proc \
  -it bb \
  /bin/bash

docker run --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /usr/bin/dockerd:/usr/bin/dockerd \
  -it bb \
  /bin/bash

bucketbench run -b /app/bench.yaml
bucketbench run -b /app/bench-run.yaml --log-level info -o -s