Building Voyage Linux image for PC Engines ALIX platforms
=========================================================

Intro
-----
* Example DIRECTORY_TO_CF_CARD_DEVICE used in instruction: `/dev/sdc`
* Voyage Linux image downloaded from `http://pcengines.ch` website has no
`flashrom` and `cbmem` installed
* Voyage Linux kernel of image downloaded from `http://pcengines.ch` website has
`CONFIG_CPU_FREQ` option not set, which could be required for `coreboot 4.7.x`
* Linux Voyage default login/password: `root/voyage`
* Linux Voyage default serial console baudrate: `38400`

Requirements
------------
* Compact Flash with a minimum of 1 GB of memory
* Compact Flash cards reader

Flashing CF card with Voyage Linux image from `http://pcengines.ch`
-------------------------------------------------------------------

1. Download [Voyage Linux image for Alix platforms](http://pcengines.ch/file/voyage-0.9.2.img.zip).

2. Unmount all mounted in OS partitions of used CF card:

```
sudo umount <DIRECTORY_TO_CF_CARD_DEVICE>*
```
Eg.:
```
sudo umount /dev/sdc*
```

3. 2. Unzip downloaded file and Flash your CF flash with unzipped image:

```
unzip -p voyage-0.9.2.img.zip

```
sudo dd if=voyage-0.9.2.img of=<DIRECTORY_TO_CF_CARD_DEVICE> bs=16M
```

Eg.:
```
sudo dd if=voyage-0.9.2.img of=/dev/sdc bs=16M
```

After succesful CF card flashing information similar to shown below may appear:
```
60+1 records in
60+1 records out
1014644736 bytes (1.0 GB, 968 MiB) copied, 32.4125 s, 31.3 MB/s
```

> It's important to don't interrupt flashing process.

After successful performing steps shown above Voyage Linux image may be 
installed on your CF card.

`cbmem` and `flashrom` installation
-----------------------------------

Boot to your OS and follow steps contained in the following instructions:

[`cbmem` installation](./cbmem_building.md)

[`flashrom` installation](./flashrom_building.md)

Changing serial console baudrate
--------------------------------

To change set serial console baudrate to not default value follow steps 
contained in [this instruction](./os_boot_serial_console.md).

Voyage Linux kernel modification
--------------------------------

There is possibility to kernel configuration without building new Voyage Linux
image. To do that you can use debian packages. 

1. Check your kernel version on target device

```
uname -r
```
2. Send config file from /boot/voyage-conf to your PC

2. Find and download the same version of kernel from kernel.org

3. Run docker container:
```
pc-engines/apu2
```
3. build kernel

4. build deb packages
.
5. Send them to target device

6. Install packages on target device

```
dpkg -i name of image package
```
That process changes grub configuration. Adds new positions on list
Often serial console redirections is disabled. To change this follow
[this instruction](./)

