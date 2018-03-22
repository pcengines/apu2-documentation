coreboot-4.7.x porting notes
============================

This file gather information about coreboot-4.7.x porting effort which cover
transition of changes introduced on coreboot-4.6.x branch on top of recent
coreboot release (4.7).

32bit toolchain
===============

`sortbootorder` crash when compiled using 64bit toolchain this is probably
related to memory functions exposed by libpayload.

To correctly compile SDK toolchain on `coreboot-4.7.x` branch you should use:

```
cd coreboot/util/docker
make DOCKER_COMMIT=fd470f716370 COREBOOT_CROSSGCC_PARAM=build-i386 coreboot-sdk
```

`DOCKER_COMMIT` means 4.7 tag since we want to be sure we rely on toolchain
tied to 4.7 release. This is not exactly true because container use Debian sid
which is moving target and 2 Docker images/toolchains may be different.
`COREBOORT_CROSSGCC_PARAMS` tell to build just i386 toolchain.

