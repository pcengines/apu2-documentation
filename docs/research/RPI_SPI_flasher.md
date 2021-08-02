# RPI flasher

## Contents

<!-- TOC -->

- [RPI flasher](#rpi-flasher)
    - [Contents](#contents)
    - [Installing flashrom on RPi](#installing-flashrom-on-rpi)
    - [First approach](#first-approach)
        - [Connection](#connection)
        - [Hexdumps of binaries:](#hexdumps-of-binaries)
        - [Problems](#problems)
        - [Conclusion](#conclusion)
    - [Second approach](#second-approach)
        - [Connection](#connection-1)
        - [Flashing](#flashing)
        - [Conclusion](#conclusion-1)

<!-- /TOC -->

## Installing flashrom on RPi

> Assuming Raspberry Jassie is running on RPi

1. Getting the latest flashrom source code:

    ```
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install build-essential pciutils usbutils libpci-dev \
    libusb-dev libftdi1 libftdi-dev zlib1g-dev subversion libusb-1.0-0-dev
    svn co https://code.coreboot.org/svn/flashrom/trunk ~/flashrom
    cd ~/flashrom
    make
    sudo make install
    ```

2. Flashing:

    If SPI device is not visible, enable SPI in:

    ```
    sudo raspi-config
    ```

    > spi_bcmxxxx modules may differ on different RPi's

    ```
    sudo modprobe spi_bcm2835
    sudo modprobe spidev
    ```

    Read from flash:

    ```
    sudo flashrom -V -p linux_spi:dev=/dev/spidev0.0 -r coreboot.rom
    ```

## First approach

### Connection

 RPI3 pin GPIO | APU2 pin J6
:-------------:|:----------:
 25 GND        | 2
 24 /CS        | 3
 23 SCK        | 4
 21 DO         | 5
 19 DI         | 6
 17 VCC        | 1


### Hexdumps of binaries:

* [original
  binary](https://drive.google.com/open?id=0B2fOAKKiyr_yY3VYS0FZV3NqMVE)
* [binary read by
  RPI](https://drive.google.com/open?id=0B2fOAKKiyr_ydmxTWm4xN1VQZmM)

### Problems

* Programming takes a lot of time (~30min.)
* ERASE problems

```sh
time ./flashrom -p linux_spi:dev=/dev/spidev0.0 -w ../apu2_v4.0.10.rom

flashrom v0.9.9-r1954 on Linux 4.9.28+ (armv6l)
flashrom is free software, get the source code at https://flashrom.org

Calibrating delay loop... OK.
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) on linux_spi.
Reading old flash chip contents... done.
Erasing and writing flash chip... FAILED at 0x0002b000! Expected=0xff, Found=0x00, failed byte count from 0x0002b000-0x0002bfff: 0x800
ERASE FAILED!
Reading current flash chip contents... done. Looking for another erase function.
FAILED at 0x0002c73c! Expected=0xff, Found=0xf0, failed byte count from 0x00028000-0x0002ffff: 0x4c4
ERASE FAILED!
Reading current flash chip contents... done. Looking for another erase function.
FAILED at 0x00020000! Expected=0xff, Found=0x00, failed byte count from 0x00020000-0x0002ffff: 0x10000
ERASE FAILED!
Reading current flash chip contents... done. Looking for another erase function.
FAILED at 0x00000000! Expected=0xff, Found=0x00, failed byte count from 0x00000000-0x007fffff: 0x800000
ERASE FAILED!
Reading current flash chip contents... done. Looking for another erase function.
FAILED at 0x00000000! Expected=0xff, Found=0x00, failed byte count from 0x00000000-0x007fffff: 0x800000
ERASE FAILED!
Looking for another erase function.
No usable erase functions left.
FAILED!
Uh oh. Erase/write failed. Checking if anything has changed.
Reading current flash chip contents... done.
Apparently at least some data has changed.
Your flash chip is in an unknown state.
Please report this on IRC at chat.freenode.net (channel #flashrom) or
mail flashrom@flashrom.org, thanks!

real	30m5.560s
user	0m5.320s
sys	0m37.830s
```

### Conclusion

* problems with WP and HOLD pins. Pull-up is not strong enough.

## Second approach

### Connection

> VCC is **not** connected!

 RPI3 pin GPIO | APU2 pin J6
:-------------:|:----------:
 25 GND        | 2
 24 /CS        | 3
 23 SCK        | 4
 21 DO         | 5
 19 DI         | 6

Power supply needs to be connected to APU2, but device needs to be powered off.
It can be done by shorting pins 2-3 on J2 connector

### Flashing

```
pi@raspberrypi:~/flashrom $ time ./flashrom -p linux_spi:dev=/dev/spidev0.0 -w ../apu2_v4.0.10.rom
flashrom v0.9.9-r1954 on Linux 4.9.28+ (armv6l)
flashrom is free software, get the source code at https://flashrom.org

Calibrating delay loop... OK.
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) on linux_spi.
Reading old flash chip contents... done.
Erasing and writing flash chip... Erase/write done.
Verifying flash... VERIFIED.

real    8m27.989s
user    0m18.760s
sys    0m11.140s
pi@raspberrypi:~/flashrom $ time ./flashrom -p linux_spi:dev=/dev/spidev0.0 -r coreboot2.rom
flashrom v0.9.9-r1954 on Linux 4.9.28+ (armv6l)
flashrom is free software, get the source code at https://flashrom.org

Calibrating delay loop... OK.
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) on linux_spi.
Reading flash... done.

real    3m46.537s
user    0m0.830s
sys    0m4.940s
pi@raspberrypi:~/flashrom $ md5sum coreboot2.rom ../apu2_v4.0.10.rom
cf0b80e2a51a28a57bf91540bdbf957c  coreboot2.rom
cf0b80e2a51a28a57bf91540bdbf957c  ../apu2_v4.0.10.rom
```

After flash, `spidev` and `spi_bcm2835` need to be unloaded and then APU2 can
be powered on.

### Conclusion

Flashing is possible, but could take a while. Need to follow the procedure
to flash the device and boot it after the process.
