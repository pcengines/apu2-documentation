APUx firmware flashing
----------------------

To flash firmware image to APUx SPI install (or use system with already
installed) [flashrom](https://www.flashrom.org/Flashrom).

For Debian-based distributions you can install `flashrom` by simply:

```sh
sudo apt-get install flashrom
```

You can also use minimal distributions with already installed `flashrom` like
[TinyCoreLinux](http://www.pcengines.ch/howto.htm#TinyCoreLinux).

## coreboot.rom flashing

##### APU1
```sh
flashrom -w coreboot.rom -p internal -c "MX25L1605A/MX25L1606E/MX25L1608E"
```

##### APU2/3/4/5
```sh
flashrom -w coreboot.rom -p internal
```

A full power cycle is required after flashing. If it is not possible (e.g.
remote firmware upgrade), when flashing coreboot v4.9.0.4 or newer a full reset
can be forced with the following commands after using `flashrom`. For older
firmware versions please refer to [cold_reset.md](cold_reset.md#forcing-cold-reset-from-started-os).

##### Linux

```sh
setpci -s 18.0 6c.L=10:10
```

##### FreeBSD

```sh
pciconf -w pci0:24:0 0x6c 0x580ffe10
```

After that reboot as usual. Platform will turn off for 3-5 seconds. Note that
there are parts of the platform which cannot be reset with this approach. A full
power cycle is strongly suggested when possible.

## Motherboard mismatch warning

When you update firmware and try to flash image to apu board, `motherboard
mismatch warning` can be yielded. It is known issue related to SMBIOS table
entries. Since `v4.6.7` in mainline and `v4.0.15` in legacy, part number entry
is in shorter (correct) form. Therefore, if you update to those version (or
newer) a warning will appear. To flash BIOS correctly, just add `-p
internal:boardmismatch=force` flag. Entire flashing command should look like
this:

```sh
flashrom -w coreboot.rom -p internal:boardmismatch=force
```

Developer tricks
----------------

To automate firmware update while developing copy ssh keys to target machine:

```sh
cat ~/.ssh/id_rsa.pub | ssh root@192.168.0.101 'cat >> .ssh/authorized_keys'
```

Then you can use below command to flash APU2 recently built changes:

```sh
APU2_IP=192.168.0.101 && ssh root@$APU2_IP remountrw && \
scp build/coreboot.rom root@$APU2_IP:/root && \
ssh root@$APU2_IP flashrom -w /root/coreboot.rom -p internal \
&& ssh root@$APU2_IP reboot
```
