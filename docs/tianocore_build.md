# Coreboot with tianocore payload on apu2

This documentation describes how to build coreboot image with tianocore payload
for PC Engines apu2 platform.

## Building coreboot image

1. Download coreboot-sdk docker image
```
docker pull coreboot/coreboot-sdk:1.52
```

2. Run docker container with passing coreboot project directory
```
docker run --rm -it -v <coreboot-directory>:/home/coreboot coreboot/coreboot-sdk:1.52 /bin/bash
```

  Notice that `<coreboot-directory>` is your local directory with coreboot
  project. `/home/coreboot` will be directory for that project in docker
  container. Therefore, it's up to you what path to give.  

3. In docker container go to coreboot main folder
```
coreboot@32ceb7327125:/$ cd home/coreboot
coreboot@32ceb7327125:~$ ls
3rdparty  CHANGELOG.md	COPYING  Documentation	MAINTAINERS  Makefile  
Makefile.inc  README.md	build  configs	gnat.adc  payloads  src  toolchain.inc
util
```

4. Run distclean
```
coreboot@32ceb7327125:~$ make distclean
```

5. Copy config file for target platform
```
coreboot@32ceb7327125:~$ cp configs/config.pcengines_apu2 .config
```

6. Run olddefconfig
```
coreboot@32ceb7327125:~$ make olddefconfig
```

7. Run menuconfig
```
coreboot@32ceb7327125:~$ make menuconfig
```

8. In menuconfig go to `Payload` menu and next:

  a. In `Add a payload` choose *Tianocore coreboot payload package*

  b. Select tianocore build type (debug or release)

  c. In `Secondary Payloads` disable all options

  d. Rest options in `Payload` menu leave default

  e. Save settings and leave menuconfig

9. Run make
```
coreboot@32ceb7327125:~$ make
```

10. After successful build coreboot image file is in *coreboot/build* directory.

## Coreboot + tianocore working example

To enter Boot Manager Menu press `F2` or `down arrow` after the message shows
up. There is 3s timeout which will proceed directly to booting if no key (or
`Enter`) was pressed.

In `Boot Manager` user can see what bootable device are visible and what is boot
order. UEFI Shell is shown also and in default settings it is always last boot
option. Selecting the highlighted option will lead to boot process from selected
device.

In `Boot Maintenance Manager` user has access to change some basic options, such
as boot order or console options. However, it is not recommended to change
serial console options, due to possibility of connection lost.

[Following example](https://asciinema.org/a/254543) is showing how expected
output should looks like and how to move in UEFI shell menu. It was tested on
apu4 platform, to which bootable USB stick was attached. As you can see, USB is
a primary device in boot order menu. Hence, it always boot from it. To enter
UEFI Shell, you need to choose it manually from Boot Manager.
