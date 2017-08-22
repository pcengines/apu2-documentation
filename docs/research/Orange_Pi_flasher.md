# Orange Pi flasher

## Contents

<!-- TOC -->

- [Orange Pi flasher](#orange-pi-flasher)
    - [Contents](#contents)
    - [Installing armbian on Orange Pi](#installing-armbian-on-orange-pi)
    - [Installing flashrom on Orange Pi](#installing-flashrom-on-rpi)
    - [Connection](#connection)
    - [Flashing](#flashing)

<!-- /TOC -->

## Installing armbian on Orange Pi

Prepare a SD card with armbian image on it first.
Download the image from
[here](https://dl.armbian.com/orangepizero/Debian_jessie_dev.7z)
and extract it to your SD card.

## Installing flashrom on Orange Pi

Put the SD card into Orange Pi and boot it. Then install flashrom using the
following commands:
```
git clone https://github.com/flashrom/flashrom.git
cd flashrom
make CONFIG_ENABLE_LIBPCI_PROGRAMMERS=no install
```

Enable SPI on Orange Pi:
```
echo "overlays=spi-spidev" >> /boot/armbianEnv.txt
echo "param_spidev_spi_bus=1" >> /boot/armbianEnv.txt
reboot
```
> Important! Put these lines in armbianEnv.txt file only once. This file
contains overall system configuration and should not contain duplicates.

## Connection

Orange Pi pinout:

![Orange Pi Pinout](https://i1.wp.com/oshlab.com/wp-content/uploads/2016/11/Orange-Pi-Zero-Pinout-banner2.jpg)


 Orange Pi pins | APU2 pin J6
:--------------:|:----------:
 GND            | 2
 SPI1_CS        | 3
 SPI1_CLK       | 4
 SPI1_MISO      | 5
 SPI1_MOSI      | 6
 
Also shorten 2-3 pins on APU2 J2 to enable S5 state.
 
## Flashing

Make sure that APU2 was powered up with shortened 2-3 pins on J2. After Orange
Pi reboot type following command:

```
flashrom -p linux_spi:dev=/dev/spidev1.0 -w coreboot.rom
```


> Note that coreboot.rom should be the rom file You are trying to write.

Correct output should look like this:
```
root@orangepizero:~# flashrom -w ./apu2_v4.6.0.rom -p linux_spi:dev=/dev/spidev1.0                          
flashrom 0.9.9-45-g4d440a7 on Linux 4.11.3-sun8i (armv7l)
flashrom is free software, get the source code at https://flashrom.org

Using clock_gettime for delay loops (clk_id: 1, resolution: 1ns).
Found Winbond flash chip "W25Q64.V" (8192 kB, SPI) on linux_spi.
Reading old flash chip contents... done.
Erasing and writing flash chip...
Warning: Chip content is identical to the requested image.
Erase/write done.
```