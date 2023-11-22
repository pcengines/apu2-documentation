iPXE - compilation, configuration and including in firmware
-----------------------------------------------------------

> NOTE: this procedure applies to legacy releases older than v4.0.14

## Compilation

1. Prepare [build environment](https://github.com/pcengines/apu2-documentation/blob/864294e6c2219d70f174272f2e1b5f99b8b7b1db/docs/building_env.md),
if you haven't done so yet
2. [Build firmware](https://github.com/pcengines/apu2-documentation/blob/864294e6c2219d70f174272f2e1b5f99b8b7b1db/docs/building_firmware.md),
if you haven't done so yet
3. Clone iPXE repository:

    ```
    git clone git@github.com:pcengines/ipxe.git
    ```

4. Configure and run build in container:

    ```
    docker run -v ${PWD}/../src/coreboot:/coreboot -v ${PWD}/../src/ipxe:/ipxe -t -i pc-engines/apu2b
    cd /ipxe
    wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/general.h -O src/config/local/general.h
    wget https://raw.githubusercontent.com/pcengines/apu2-documentation/master/ipxe/shell.ipxe -O src/shell.ipxe
    ```

    `wget` downloads iPXE configuration that maximize feature set that is
    exposed. Supported features:

    * net proto: IPV4, IPV6, STP
    * download proto: TFTP, HTTP, HTTPS, FTP, SLAM, NFS
    * image: NBI, ELF, MULTIBOOT, PXE, SCRIPT, BZIMAGE, COMBOOT, SDI, PNM, PNG

    For more details please check [general.h](https://github.com/pcengines/apu2-documentation/blob/master/ipxe/general.h).

    ```
    make bin/8086157b.rom EMBED=./shell.ipxe
    ```

    Note that `${PWD}/../src/ipxe` is absolute path to repository cloned in
    point 3.

As a result you will have `bin/8086157b.rom`

## Including in firmware image

To include iPXE ROM in `coreboot.rom` please use `cbfstool`.

To add iPXE ROM to existing image inside container:

```
cd /
./coreboot/build/cbfstool ./coreboot/build/coreboot.rom add -f /ipxe/src/bin/8086157b.rom -n genroms/pxe.rom -t raw
```

If you already have `genroms/pxe.rom`, please remove it and then add new
version:

```
./coreboot/build/cbfstool ./coreboot/build/coreboot.rom remove -n genroms/pxe.rom
```

