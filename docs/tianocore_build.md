# Coreboot with tianocore payload on apu2
=========================================

This document describes how to build coreboot image with tianocore payload for
PC Engines apu2 platform. Payload is supported since v4.9.0.7 release.

## Building coreboot image

1. Clone the [pce-fw-builder](https://github.com/pcengines/pce-fw-builder)
2. Pull or [build](https://github.com/pcengines/pce-fw-builder#building-docker-image)
  docker container:

  ```
  docker pull pcengines/pce-fw-builder
  ```

3. Build v4.9.0.7 image:

  ```
  ./build.sh release v4.9.0.7 apu2
  ```

4. Invoke distclean:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 distclean
  ```

5. Copy config file for target platform

  ```
  cp $PWD/release/coreboot/configs/config.pcengines_apu2 $PWD/release/coreboot/.config
  ```

6. Create full config:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 olddefconfig
  ```

7. Invoke menuconfig:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 menuconfig
  ```

8. In menuconfig go to `Payload` menu and next:

  - In `Add a payload` choose *Tianocore coreboot payload package*
  - Select tianocore build type release
  - In `Secondary Payloads` disable all options
  - Rest options in `Payload` menu leave default
  - Save settings and leave menuconfig

9. Build coreboot image

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 CPUS=$(nproc)
  ```

10. After successful build coreboot image file is in `release/coreboot/build`
directory.

## Coreboot + tianocore working example

To enter Boot Manager Menu press `F2` or `down arrow` after the message shows
up. There is 3s timeout which will proceed directly to booting if no key (or
`Enter`) was pressed.

In `Boot Manager` user can see what bootable device are visible and what is boot
order. UEFI Shell is shown also and in default settings it is always last boot
option. Selecting the highlighted option will lead to boot process from selected
device.

>NOTE: It may happen that even if device is seen in boot menu, tianocore could
not boot from it. It is because OS on the selected device uses legacy mode and
therefore it is not UEFI-aware system.

In `Boot Maintenance Manager` user has access to change some basic options, such
as boot order or console options. However, it is not recommended to change
serial console options, due to possibility of connection lost.

[Following example](https://asciinema.org/a/254543) is showing how expected
output should looks like and how to move in UEFI shell menu. It was tested on
apu4 platform, to which bootable USB stick was attached. As you can see, USB is
a primary device in boot order menu. Hence, it always boot from it. To enter
UEFI Shell, you need to choose it manually from Boot Manager.
