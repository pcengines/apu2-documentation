Building environment
--------------------

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

Clone this repository:

```
git clone git@github.com:pcengines/apu2-documentation.git
cd apu2-documentation
```

Build Ubuntu LTS 14.04 based image:

```
docker build -t pc-engines/apu2b .
```

After successful build you will have image based on which you can create
containers that can be used as build environment for PC Engines APU2 firmware.

### Run container

```
docker run -v ${PWD}/../src/coreboot:/coreboot -t -i pc-engines/apu2b
```

This command runs container using previously created image. Note that
`${PWD}/../src/coreboot` is absolute path to coreboot source code. You can find
this repository [here](https://github.com/pcengines/coreboot).


