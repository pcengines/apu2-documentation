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
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build
```

Or for mainline coreboot:

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build-ml
```

## Flash release

Note that below script assume that you have ssh enabled connection with target
device and destination OS [APU2 image builder](https://github.com/pcengines/apu2-documentation#building-firmware-using-apu2-image-builder).
Without keys added you will see question about password couple times during
flashing.

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh flash <user>@<ip_address>
```

For mainline:

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh flash-ml <user>@<ip_address>
```

Best way is to use `root` as `<user>` because it can h

## Changes to work on mainline

`.gitmodules` have to be changed with this patch:

```
diff --git a/.gitmodules b/.gitmodules
index c3270e6ae2f2..5c1b495dea1a 100644
--- a/.gitmodules
+++ b/.gitmodules
@@ -1,23 +1,23 @@
 [submodule "3rdparty/blobs"]
        path = 3rdparty/blobs
-       url = ../blobs.git
+       url = ssh://<username>@review.coreboot.org:29418/blobs.git
        update = none
        ignore = dirty
 [submodule "util/nvidia-cbootimage"]
        path = util/nvidia/cbootimage
-       url = ../nvidia-cbootimage.git
+       url = ssh://<username>@review.coreboot.org:29418/nvidia-cbootimage.git
 [submodule "vboot"]
        path = 3rdparty/vboot
-       url = ../vboot.git
+       url = ssh://<username>@review.coreboot.org:29418/vboot.git
 [submodule "arm-trusted-firmware"]
        path = 3rdparty/arm-trusted-firmware
-       url = ../arm-trusted-firmware.git
+       url = ssh://<username>@review.coreboot.org:29418/arm-trusted-firmware.git
 [submodule "3rdparty/chromeec"]
        path = 3rdparty/chromeec
-       url = ../chrome-ec.git
+       url = ssh://<username>@review.coreboot.org:29418/chrome-ec.git
 [submodule "libhwbase"]
        path = 3rdparty/libhwbase
-       url = ../libhwbase.git
+       url = ssh://<username>@review.coreboot.org:29418/libhwbase.git
 [submodule "libgfxinit"]
        path = 3rdparty/libgfxinit
-       url = ../libgfxinit.git
+       url = ssh://<username>@review.coreboot.org:29418/libgfxinit.git
```

## Known issues

### using repo with coreboot show errors like:

```
fatal: Not a git repository (or any parent up to mount point /coreboot)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
``` 

Since it use `git` commands to create build timestamp.

#### flashing doesn't work

```
[21:51:53] pietrushnic:apu2_fw_rel $ ../apu2-documentation/scripts/apu2_fw_rel.sh flash-ml pcengines@192.168.0.103
flash-ml pcengines@192.168.0.103
The authenticity of host '192.168.0.103 (192.168.0.103)' can't be established.
(...)
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.0.103' (ECDSA) to the list of known hosts.
bash: remountrw: command not found
coreboot.rom                                                                                                                                                                                                100% 8192KB   8.0MB/s   00:00    
sudo: no tty present and no askpass program specified
sudo: no tty present and no askpass program specified
```
