APU2 firmware flashing
----------------------

To flash firmware image to APU2 SPI install (or use system with already
installed) [flashrom](https://www.flashrom.org/Flashrom).

For Debian-based distributions you can install `flashrom` by simply:

```
sudo apt-get install flashrom
```

You can also use minimal distributions with already installed `flashrom` like
[TinyCoreLinux](http://www.pcengines.ch/howto.htm#TinyCoreLinux).

## coreboot.rom flashing

```
flashrom -w coreboot.rom -p internal
```

Developer tricks
----------------

To automate firmware update while developing copy ssh keys to target machine:

```
cat ~/.ssh/id_rsa.pub | ssh root@192.168.0.101 'cat >> .ssh/authorized_keys'
```

Then you can use below command to flash recently built changes:

```
APU2_IP=192.168.0.101 && ssh root@$APU2_IP remountrw && \
scp build/coreboot.rom root@$APU2_IP:/root && \
ssh root@$APU2_IP flashrom -w /root/coreboot.rom -p internal \
&& ssh root@$APU2_IP reboot
```
