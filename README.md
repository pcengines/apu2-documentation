Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
APU2 platform users and developers to customize firmware to their needs.

Building firmware using APU2 image builder
------------------------------------------

Get APU2 image builder from [here](http://pcengines.ch/file/apu2_image_builder_v0.1.img.xz) (MD5 sum after decompression: a40ea9caff93c0218a745e0625e1292a).

```
User/pass: root/voyage
```

1. Unpack image:

    ```
    tar xf apu2_image_builder_v0.1.img.xz
    ```

2. write image to SD/mSATA/USB
3. boot the APU2 board with this image
4. run below commands

    ```
    remountrw
    wget https://github.com/pcengines/coreboot/archive/apu2b-20160304.zip
    unzip apu2b-20160304.zip
    cd coreboot-apu2b-20160304/
    cp /xgcc/.xcompile . # this command setup toolchain
    cp configs/pcengines.apu2.20160304.config .config
    make
    ```

5. once done find the new firmware in the build folder (`build/coreboot.rom`)
6. see [here](http://pcengines.ch/howto.htm#bios) for instructions on how to
   flash the firmware

Building iPXE
-------------

```
cd coreboot-apu2b-20160304/
IPXE_PATH=payloads/external/ipxe
git clone https://github.com/pcengines/ipxe $IPXE_PATH
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/general.h -O $IPXE_PATH/src/config/local/general.h
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/shell.ipxe -O $IPXE_PATH/src/shell.ipxe
cd $IPXE_PATH/src
make bin/8086157b.rom EMBED=./shell.ipxe
```

Feel free to customize `shell.pxe` and `local/general.h` to match your needs.

Building sortbootorder
----------------------

Please check [here](https://github.com/pcengines/sortbootorder).

NOTE: `sortbootorder` payload is not yet supported on APU2.

Building memtest86+
-------------------

```
cd coreboot-apu2b-20160304/
git clone https://github.com/pcengines/memtest86plus.git -b apu2 payloads/external/memtest86plus
cd payloads/external/memtest86plus
make
```

cbfstool and adding/removing ROMs or payloads
---------------------------------------------

`cbfstool` is result of `coreboot` build it gives ability to manipulate CBFS
which filesystem for coreboot ROM.

Usage examples:

### Add iPXE ROM

```
cd coreboot-apu2b-20160304/
./build/cbfstool ./build/coreboot.rom add -f payloads/external/ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
```

Above command add raw image (`8086157b.rom`, result of iPXE build) to
`coreboot.rom` under the name `genroms/pxe.rom`. This makes SeaBIOS to auto
detect iPXE ROM and execute it before entering menu.

### Add sortbootorder

```
# add sortbootorder
cd coreboot-apu2b-20160304/
./build/cbfstool ./build/coreboot.rom remove -n img/setup
./build/cbfstool ./build/coreboot.rom add-payload -f payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
```

Above commands first remove already existing `img/setup` from CBFS and then add
`sortbootorder.elf` as payload under the name `img/setup` to `coreboot.rom`.


### Add memtest86+

```
# add memtest86+
cd coreboot-apu2b-20160304/
./build/cbfstool ./build/coreboot.rom remove -n img/memtest
./build/cbfstool ./build/coreboot.rom add-payload -f payloads/external/memtest86plus/memtest -n img/memtest - payload
```

Cross compilation with Docker container
---------------------------------------

For advanced users and developers there maybe need to have development
environment that is separated for working environment. Because of that you can
use Docker containers as descried below.

1. [Building environment](docs/building_env.md)
2. [Building firmware](docs/building_firmware.md)
3. [iPXE - compilation, configuration and including in firmware image](docs/ipxe_compile.md)
4. [APU2 firmware flashing](docs/firmware_flashing.md)

Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
