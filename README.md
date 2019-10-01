# container benchmarks

a collection of benchmarks to compare different docker-compattible IoT container platforms and environments

- baseline measurements of performance
    - iozone for disk read/writes
    - STREAM for memory performannce
    - NAS for parallel (CPU) performance
    - ApacheBench for network performance


- container-specific benchmarks
    - spinup time
    - isolation capabilities (noisy neighbour isolation for different configuations)
    - 


# process

container isolation properties




# init
from a management console (I'm using ubuntu), you can init the different envs by doing the following:

```
ssh USER@HOST 'bash -s' < SCRIPT    # usually init.sh
```


# notes
use node 10 (install with nvm) for balena-cli

enable experimental for docker buildx: https://github.com/docker/buildx#docker-ce

