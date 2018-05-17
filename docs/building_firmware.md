Building firmware
=================

> NOTE: this document applies only to releases older than v4.0.17 and v4.6.9

coreboot-4.5.x, coreboot-4.6.x
--------------

1. Prepare [build environment](building_env.md), if you haven't done so yet
2. Create working directory:

    ```sh
    mkdir apu_coreboot
    cd apu_coreboot
    ```

3. Clone PC Engines coreboot repository:

    ```sh
    # git clone -b coreboot-4.5.x git@github.com:pcengines/coreboot.git
    git clone -b coreboot-4.5.x https://github.com/pcengines/coreboot.git
    # git clone git@github.com:pcengines/apu2-documentation.git
    git clone https://github.com/pcengines/apu2-documentation.git
    ```
> Use coreboot-4.5.x or coreboot-4.6.x branch respectively

4. Run contatiner with correct path to working directory (can be bypassed, if
    coreboot builds on host Linux):

    ```sh
    docker run --rm \
        -v ${PWD}:/workdir \
        -t -i pc-engines/apu2 bash
    ```

5. Configure coreboot (inside the container):

    ```sh
    cd /workdir/coreboot
    make menuconfig
    ```

    * select `Mainboard` > `Mainboard vendor` = `PC Engines`
    * select `Mainboard` > `Mainboard model` = `APU2` (or `APU3`)

6. Build crossgcc:

    ```sh
    make crossgcc-i386
    ```

7. Build coreboot:

    ```sh
    make
    ```

coreboot-4.0.x
--------------

1. Prepare [build environment](building_env.md), if you haven't done so yet
2. Clone PC Engines coreboot repository:

    ```
    # git clone -b coreboot-4.0.x git@github.com:pcengines/coreboot.git
    git clone -b coreboot-4.0.x https://github.com/pcengines/coreboot.git
    # git clone git@github.com:pcengines/memtest86plus.git
    git clone https://github.com/pcengines/memtest86plus.git
    # git clone git@github.com:pcengines/ipxe.git
    git clone https://github.com/pcengines/ipxe.git
    # git clone git@github.com:pcengines/sortbootorder.git
    git clone https://github.com/pcengines/sortbootorder.git
    ```
3. Run container and provide absolute path to above repositories

    ```
    docker run -v ${PWD}/coreboot:/coreboot \
    -v ${PWD}/memtest86plus:/memtest86plus \
    -v ${PWD}/ipxe:/ipxe \
    -v ${PWD}/sortbootorder:/coreboot/payloads/pcengines/sortbootorder \
    -t -i pc-engines/apu2b bash
    ```

4. Inside container

    ```
    cd /coreboot
    cp configs/pcengines.apu2.20160304.config .config
    make crossgcc-i386 CPUS=4
    make
    ```

    Note that building toolchain `make crossgcc-i386` is needed only once.

5. Compile payloads

    ```
    # ipxe
    IPXE_PATH=/ipxe
    wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/general.h -O $IPXE_PATH/src/config/local/general.h
    wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/menu.ipxe -O $IPXE_PATH/src/menu.ipxe
    cd $IPXE_PATH/src
    make bin/8086157b.rom EMBED=./menu.ipxe
    # sortbootorder
    cd /coreboot/payloads/libpayload
    wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/xcompile/.xcompile-libpayload
    make clean
    make defconfig
    make
    make install
    cd ../pcengines/sortbootorder
    make
    # memtest86plus
    cd /memtest86plus
    make
    ```
6. Add payloads to image

   ```
   cd /coreboot
   # ./build/cbfstool ./build/coreboot.rom remove -n genroms/pxe.rom
   ./build/cbfstool ./build/coreboot.rom add -f /ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
   ./build/cbfstool ./build/coreboot.rom remove -n img/setup
   ./build/cbfstool ./build/coreboot.rom add-payload -f payloads/pcengines/sortbootorder/sortbootorder.elf -n img/setup -t payload
   ./build/cbfstool ./build/coreboot.rom remove -n img/memtest
   ./build/cbfstool ./build/coreboot.rom add-payload -f /memtest86plus/memtest -n img/memtest - payload
   ```

As a result you will have `build/coreboot.rom` file which is our firmware for
APU2 board. Now you can continue with [flashing firmware](firmware_flashing.md).


Logs
----

### make crossgcc-i386 log

```
Warning: no suitable GCC for arm.
Warning: no suitable GCC for arm64.
Warning: no suitable GCC for riscv.
Welcome to the coreboot cross toolchain builder v1.26 (February 23th, 2015)

Target arch is now i386-elf
Will skip GDB ... ok
Downloading tar balls ...
 * gmp-5.1.2.tar.bz2 (downloading)
 * mpfr-3.1.2.tar.bz2 (downloading)
 * mpc-1.0.3.tar.gz (downloading)
 * libelf-0.8.13.tar.gz (downloading)
 * gcc-4.8.3.tar.bz2 (downloading)
 * binutils-2.23.2.tar.bz2 (downloading)
 * acpica-unix-20140114.tar.gz (downloading)
Downloaded tar balls ... ok
Unpacking and patching ...
 * gmp-5.1.2.tar.bz2
 * mpfr-3.1.2.tar.bz2
 * mpc-1.0.3.tar.gz
 * libelf-0.8.13.tar.gz
 * gcc-4.8.3.tar.bz2
 * binutils-2.23.2.tar.bz2
   o binutils-2.23.2_armv7a.patch
   o binutils-2.23.2_no-bfd-doc.patch
 * acpica-unix-20140114.tar.gz
Unpacked and patched ... ok
Building GMP 5.1.2 ... ok
Building MPFR 3.1.2 ... ok
Building MPC 1.0.3 ... ok
Building libelf 0.8.13 ... ok
Building binutils 2.23.2 ... ok
Building GCC 4.8.3 ... ok
Skipping Expat (Python scripting not enabled)
Skipping Python (Python scripting not enabled)
Skipping GDB (GDB support not enabled)
Building IASL 20140114 ... ok
fatal: No tags can describe '8fd1660e3319d71f72c84d1470acb1c73f62a801'.
Try --always, or create some tags.
Cleaning up... ok

You can now run your i386-elf cross toolchain from /coreboot/util/crossgcc/xgcc.
```

Known issues
------------

* when building in not clean tree you can experience something like:

    ```
    root@bc00b37a5214:/coreboot# make
    Warning: no suitable GCC for arm.
    Warning: no suitable GCC for arm64.
    Warning: no suitable GCC for riscv.
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: /coreboot/3rdparty/southbridge/amd/avalon/PSP//PspNvram.bin: No such file or directory
    cat: 3rdparty/southbridge/amd/avalon/PSP/AmdPubKey.bin: No such file or directory
    cat: /coreboot/3rdparty/southbridge/amd/avalon/PSP//PspNvram.bin: No such file or directory
    This build configuration requires Hudson XHCI firmware (available in coreboot/3rdparty if enabled)
    Makefile:200: *** cannot continue build.  Stop.
    ```

    to fix that problem clean tree before build:

    ```
    make clean
    ```

* Above command may also be necessary to execute after modyfying configuration
  file (e.g. changing log level).
