Building environment
--------------------

> NOTE: this document applies only to releases older than v4.0.17 and v4.6.9

This document describe how to create firmware building environment. Below
instruction rely on [Docker containers](https://www.docker.com/) to make sure
that all dependencies were resolved and target build environment is the same
for all users. Of course users are free to choose their environment, but then
build environment issues getting best effort support - suggested method is
Docker container.

Steps were tested with Debian stretch/sid.

### Docker installation

Please follow [Docker installation instructions](https://docs.docker.com/engine/installation/) for your operating
system. Note that it is convenient to have non-root, so user added to group
`docker` may execute Docker client commands.

### Building Docker image

Get Dockerfile:

```
mkdir apu2-docker && cd apu2-docker
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/Dockerfile
```

Build Ubuntu LTS 14.04 based container image:

```
docker build -t pc-engines/apu2 .
```

After successful build you will have image based on which you can create
containers that can be used as build environment for PC Engines APU2 firmware.

Please continue to [Building firmware](building_firmware.md).
