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
