APUx firmware flashing
----------------------

To flash firmware image to APUx SPI install (or use system with already
installed) [flashrom](https://www.flashrom.org/Flashrom).

For Debian-based distributions you can install `flashrom` by simply:

```bash
sudo apt-get install flashrom
```

You can also use minimal distributions with already installed `flashrom` like
[TinyCoreLinux](http://www.pcengines.ch/howto.htm#TinyCoreLinux).

## coreboot.rom flashing

#### APU1
```bash
flashrom -w coreboot.rom -p internal -c "MX25L1605A/MX25L1606E/MX25L1608E"
```

#### APU2/3/4/5
```bash
flashrom -w coreboot.rom -p internal
```

Developer tricks
----------------

To automate firmware update while developing copy ssh keys to target machine:

```bash
cat ~/.ssh/id_rsa.pub | ssh root@192.168.0.101 'cat >> .ssh/authorized_keys'
```

Then you can use below command to flash APU2 recently built changes:

```bash
APU2_IP=192.168.0.101 && ssh root@$APU2_IP remountrw && \
scp build/coreboot.rom root@$APU2_IP:/root && \
ssh root@$APU2_IP flashrom -w /root/coreboot.rom -p internal \
&& ssh root@$APU2_IP reboot
```
