## Intro

This document described release process for new versions of firmware for PC
Engines APU2 platform. It is intended for developers who want to create fully
featured binaries and test those with various versions of sortbootorder,
SeaBIOS, memtest86+ or iPXE.

Please note that flashing without recovery procedure is not recommended and we
are not responsible for any damage that inexperienced person can do to the
system.

## Use repo tool to initialize set of repositories

```
mkdir apu2_fw_rel
cd apu2_fw_rel
repo init -u git@github.com:pcengines/apu2-documentation.git -b manifest
repo sync --force-sync
```

## Build container

This is to avoid impact of system on build results:

```
docker build -t pcengines/apu2 apu2/apu2-documentation
```

## Build release

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh
```
