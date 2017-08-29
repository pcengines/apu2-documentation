# Orange Pi flasher

## Contents

<!-- TOC -->

- [Orange Pi flasher](#orange-pi-flasher)
    - [Contents](#contents)
    - [Installing armbian on Orange Pi](#installing-armbian-on-orange-pi)
    - [Installing flashrom on Orange Pi](#installing-flashrom-on-rpi)
    - [Connection](#connection)
    - [Flashing](#flashing)
    - [Customizing kernel for armbian](#customizing-kernel-for-armbian)
    - [Updating kernel on Orange Pi Zero](#updating-kernel-on-orange-pi-zero)

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

> Be sure to use stable power supply. Do no supply OrangePi from PC USB.
> Its efficiency is not enough for proper operating of Orange Pi.
> It is strongly recommended to use 5V power supply connected to microUSB
> socket (a trusted USB charger will make it too). Using uncertain power supply
> leads to flash writing errors, which may brick your target device.

## Customizing kernel for armbian

Clone the repository first and then run script `compile.sh` (must run as root):
```
git clone --depth 1 https://github.com/armbian/build
cd build
sudo ./compile.sh
```

`compile.sh` takes care of everything. Downloads cross compilation toolchain and
all necessary tools.

>They say it works only with Ubuntu Xenial (16.04), other distros are supposed
to be not supported

This command will pop up a menu. Many options can be chosen there, but the most
important options are:

1. Select to build only kernel and uboot packages
2. Show a kernel configuration menu before compilation
3. Choose target board (in this case `orangepizero`)
4. Select the target kernel branch as `dev` for newest development version
5. Accept to enter export mode

>I followed this approach and I strongly recommend to use it this way.

Now the kernel menuconfig should pop up and the customization process begin.
After saving config and exiting, the kernel compilation will start.

## Updating kernel on Orange Pi Zero

The kernel compilation results in building debian packages in
`/repodir/build/output/debs`.

```
build/output/debs$ ls
extra 
linux-firmware-image-dev-sun8i_5.32_armhf.deb
linux-image-dev-sun8i_5.32_armhf.deb
linux-u-boot-dev-orangepizero_5.32_armhf.deb
linux-dtb-dev-sun8i_5.32_armhf.deb
linux-headers-dev-sun8i_5.32_armhf.deb
linux-source-dev-sun8i_5.32_all.deb

```

These packages need to be  sent to Orange Pi, for example via scp:

```
scp linux-image-dev-sun8i_5.32_armhf.deb root@192.168.0.112:/root/
scp linux-dtb-dev-sun8i_5.32_armhf.deb   root@192.168.0.112:/root/
scp linux-headers-dev-sun8i_5.32_armhf.deb  root@192.168.0.112:/root/
```

Only these three are necessary, because there is an u-boot and source package,
which are not needed to update the kernel.

Now connect to Orange Pi, via SSH for example, as root. Defautl password is
`armbian1234`.
Install the packages:

```
cd
dpkg -i linux-headers-dev-sun8i_5.32_armhf.deb linux-dtb-dev-sun8i_5.32_armhf.deb linux-image-dev-sun8i_5.32_armhf.deb
```

This may take a while, especially the headers package, so I advise taking
a break with coffee.

After completion directory with old headers may be still present in `/usr/src/`.
It can be safely removed if need.