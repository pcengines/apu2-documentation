Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
APU2 platform users and developers to customize firmware to their needs.

Please take a look at [changelog](CHANGELOG.md) to get information about recent
update.

Building firmware using APU2 image builder
------------------------------------------

Please note this procedure covers building `v4.0.x` firmware, which is based on
legacy code. Mainline firmware development is in progress more information can be found [here](http://pcengines.info/forums/?page=post&id=CAA8403D-7135-4EA1-8C7E-41C8B15C6246).

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
    cd
    remountrw
    export BR_NAME=coreboot-4.0.x
    wget https://github.com/pcengines/coreboot/archive/${BR_NAME}.zip
    unzip ${BR_NAME}.zip
    cd coreboot-${BR_NAME}/
    cp /xgcc/.xcompile . # this command setup toolchain
    cp configs/pcengines_apu2.config .config
    make -j$(nproc)
    ```

5. once done find the new firmware in the build folder (`build/coreboot.rom`)
6. see [here](http://pcengines.ch/howto.htm#bios) for instructions on how to
   flash the firmware

Building iPXE
-------------

```
cd && cd coreboot-${BR_NAME}
IPXE_PATH=payloads/external/ipxe
git clone https://github.com/pcengines/ipxe $IPXE_PATH
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/general.h -O $IPXE_PATH/src/config/local/general.h
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/menu.ipxe -O $IPXE_PATH/src/menu.ipxe
cd $IPXE_PATH/src
make -j$(nproc) bin/8086157b.rom EMBED=./menu.ipxe
```

Feel free to customize `menu.pxe` and `local/general.h` to match your needs.

Building sortbootorder
----------------------

```
cd && cd coreboot-${BR_NAME}
git clone https://github.com/pcengines/sortbootorder.git -b ${BR_NAME} payloads/pcengines/sortbootorder
cd payloads/libpayload
make clean && make defconfig
wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/xcompile/.apu2-builder-xcompile-libpayload -O .xcompile
make -j$(nproc)
make install
cd ../pcengines/sortbootorder
make -j$(nproc)
```

Building memtest86+
-------------------

```
cd && cd coreboot-${BR_NAME}
git clone https://github.com/pcengines/memtest86plus.git payloads/external/memtest86plus
cd payloads/external/memtest86plus
make -j$(nproc)
```

cbfstool and adding/removing ROMs or payloads
---------------------------------------------

`cbfstool` is result of `coreboot` build it gives ability to manipulate CBFS
which filesystem for coreboot ROM.

Usage examples:

### Add iPXE ROM

```
cd && cd coreboot-${BR_NAME}
./build/cbfstool ./build/coreboot.rom add -f payloads/external/ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
```

Above command add raw image (`8086157b.rom`, result of iPXE build) to
`coreboot.rom` under the name `genroms/pxe.rom`. This makes SeaBIOS to auto
detect iPXE ROM and execute it before entering menu.

### Add sortbootorder

```
# add sortbootorder
cd && cd coreboot-${BR_NAME}
./build/cbfstool ./build/coreboot.rom remove -n img/setup
./build/cbfstool ./build/coreboot.rom add-payload -f payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
```

Above commands first remove already existing `img/setup` from CBFS and then add
`sortbootorder.elf` as payload under the name `img/setup` to `coreboot.rom`.


### Add memtest86+

```
# add memtest86+
cd && cd coreboot-${BR_NAME}
./build/cbfstool ./build/coreboot.rom remove -n img/memtest
./build/cbfstool ./build/coreboot.rom add-payload -f payloads/external/memtest86plus/memtest -n img/memtest - payload
```

Cross compilation in Docker container
---------------------------------------

For advanced users and developers there maybe need to have development
environment that is separated for working environment. Because of that you can
use Docker containers as descried below.

1. [Build container](docs/building_env.md)
2. [Building firmware](docs/building_firmware.md)
3. [Firmware flashing](docs/firmware_flashing.md)

Other resources
----------------

* [sortbootorder payload](https://github.com/pcengines/sortbootorder)
  - coreboot payload that give ability to make persistent changes to boot order

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
