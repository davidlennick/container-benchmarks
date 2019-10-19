# container benchmarks

a collection of benchmarks to compare different docker-compattible IoT container platforms and environments

- baseline measurements of performance
    - iozone for disk read/writes
    - STREAM for HPC memory performannce
    - NAS for parallel (CPU) performance
    - sysbench for CPU and memory
    - bucketbench for container runtime metrics

## scripts

```
cd scripts

# init stuff
###############################################

# open ssh terminals to all rpi devices

./ssh-to-all.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97


# initialize all rpis

./init-all.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97


# login to a private registry

./add-registry.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 username password registry.address.com


# build and deploy stuff
###############################################

# build and push an image using an rpi (a lazy way to enforce arm builds)

./push-to-reg.sh pirate@10.0.0.195 hypriot registry.address.com $PWD/../containers/telegraf-client


# deploy a container using the private registry

./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.address.com telegraf-client 

./deploy-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.address.com telegraf-client "# optional docker args here \
--privileged --network=host \
  -v $PWD/telegraf.conf:/etc/telegraf/telegraf.conf:ro \
  -v /:/hostfs:ro -v /run/udev:/run/udev:ro \
  -e HOST_PROC=/hostfs/proc \
  -e HOST_MOUNT_PREFIX=/hostfs"


# deploy bucketbench (requires specific args for "balena engine")

./deploy-bucketbench.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.address.com


# stop a container running on all devices

./stop-container.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 registry.address.com npb


# clean images from rpis

./clean-all.sh 10.0.0.136 10.0.0.195 10.0.0.198 10.0.0.97 


# benchmark script
###############################################

./run-benchmark.sh

```



# notes
use node 10 (install with nvm) for balena-cli!



