Building Voyage Linux image for PC Engines ALIX platforms
=========================================================

Intro
-----
* Example DIRECTORY_TO_CF_CARD_DEVICE used in following instructions: `/dev/sdc`
* Voyage Linux [image](http://pcengines.ch/file/voyage-0.9.2.img.zip) 
downloaded from `http://pcengines.ch` website has no `flashrom` and `cbmem` 
installed
* Voyage Linux kernel of [image](http://pcengines.ch/file/voyage-0.9.2.img.zip) 
downloaded from `http://pcengines.ch` website has `CONFIG_CPU_FREQ` option not 
set, which could be required for `coreboot 4.7.x`
* Linux Voyage default login/password: `root/voyage`
* Linux Voyage default serial console baudrate: `38400`

Requirements
------------
* Compact Flash with a minimum of 1 GB of memory
* Compact Flash card reader

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

3. Unzip downloaded file and Flash your CF flash with unzipped image:

```
unzip -p voyage-0.9.2.img | pv | sudo dd of=<DIRECTORY_TO_CF_CARD_DEVICE> bs=16M

```

Eg.:
```
unzip -p voyage-0.9.2.img | pv | sudo dd of=/dev/sdc bs=16M
```

After succesful CF card flashing information similar to shown below may appear:
```
60+1 records in
60+1 records out
1014644736 bytes (1.0 GB, 968 MiB) copied, 32.4125 s, 31.3 MB/s
```

But you still may check that data copying process has been finished. To check 
that type in a new terminal or terminal tab:

```
watch grep -e Dirty: -e Writeback: /proc/meminfo
```

Then type in the first terminal command which cause cache dropping to device:
```
sync
```
and wait until `sync` process end. After that `Dirty` and `Writeback` values
should be near the `0` value. Now you can safety remove your CF card.

> It's important to not interrupt the flashing process.

After successful performing steps shown above, Voyage Linux image may be 
installed on your CF card.

`cbmem` and `flashrom` installation
-----------------------------------

Boot to your OS and follow steps contained in the following instructions:

[`cbmem` installation](./cbmem_building.md)

[`flashrom` installation](./flashrom_building.md)

Changing serial console baudrate
--------------------------------

To change serial console baudrate to custom value follow steps 
contained in [this instruction](./os_boot_serial_console.md).

Voyage Linux kernel modification
--------------------------------

There is possibility to change kernel configuration without building new Voyage 
Linux image. To do that you can use debian packages. 

1. Check your kernel version on the target device after booting to OS:

```
uname -r
```
Example output
```
3.14.12-voyage
```
That means that kernel version is `3.14.12`.

2. Find and download the same version of kernel from (https://www.kernel.org/).
Eg. for `3.14.12` is could be `3.14.X` version when `X >= 12`.
Then extract the downloaded archive with kernel files.

3. Transfer config file from target device `/boot` directory to your PC. It 
should be named similar to `config-3.14.12-voyage`.

4. Rename config file to `.config` and place in the directory where 
extracted kernel files are placed.

5. Run docker container:

```
docker run --rm -v ${PWD}:/workdir -t -i pc-engines/apu2 bash
```

If you don't have `pc-engines/apu2` environment built follow [this instruction](./building_env.md).

6. Read old config file:

```
make oldconfig
```

You can be asked there for some kernel setting. Set them as you need. 

7. Run configuration menu and enable desired kernel elements:

```
make menuconfig
```

8. Build kernel:

```
make CPUS=$(nproc)
```

9. Build debian packages:

```
make deb-pkg CPUS=$(nproc)
```

Created packages should be in the directory one level above.

7. Find package with `image` in name 
(eg. `linux-image-3.10.107_3.10.107-2_i386.deb`) and send it to the target 
device.

8. Install packages on the target device:

```
dpkg -i <name of image package>
```

Eg.
```
dpkg -i linux-image-3.10.107_3.10.107-2_i386.deb
```

That process changes grub configuration. It adds new positions on grub menu 
list. Often serial console redirection is disabled. To change this follow
[this instruction](./os_boot_serial_console.md).

9. After `reboot` system with updated kernel will be on the Grub menu list.
It will have kernel version contained within the name.
