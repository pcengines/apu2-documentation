Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
APU2 platform users to customize firmware to their needs.

Building
--------

Below procedure tested with Debian stretch/sid.

```
git clone -b apu2b-20160304 git@github.com:pcengines/coreboot.git
cd coreboot
cp configs/pcengines.apu2.20160304.config .config
make crossgcc-i386
make
```

## Flashing using TinyCore Linux

```
wget http://pcengines.ch/file/apu2-tinycore6.4.img.gz
gunzip apu2-tinycore6.4.img.gz
sudo dd if=apu2-tinycore6.4.img of=/dev/sdX bs=1M
```

Note that you have to replace `/dev/sdX` with your USB stick device.

### Transfer coreboot.rom to APU2

To transfer build result to APU2 you can use netcat:

```
apu2> nc -l -p 2020 > fw.bin
```

On host:

```
host> cat build/coreboot.rom | nc <apu2_ip_addr> 2020
```

If nc will not finish after couple seconds break its execution with `<Ctrl-C>`.
To make sure that file was transfered correctly compare MD5 sum on both
machines.

```
apu2> md5sum fw.bin
```

```
host> md5sum build/coreboot.rom
```

You should get exactly the same result.

### Running flashrom

```
apu2> flashrom -w fw.bin -p internal
```

Building in Docker container
----------------------------

If you don't want to use Voyage Linux you can use Docker container according to
procedure described below.

1. [Building environment](docs/building_env.md)
2. [Building firmware](docs/building_firmware.md)
3. [iPXE - compilation, configuration and including in firmware image](docs/ipxe_compile.md)
4. [APU2 firmware flashing](docs/firmware_flashing.md)

Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorde://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

TODO list
---------

- [ ] iPXE sample configuration through script

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
