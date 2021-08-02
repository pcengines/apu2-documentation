Microcode patching on PC Engines apu2/3/4/5
===========================================

With v4.8.0.7 release we have implemented an experimental feature of microcode
patching. Inspired by [community](https://github.com/pcengines/apu2-documentation/issues/75)
we decided to add such feature to the PC Engines firmware.

The first implementation did not work as expected unfortunately. The procedure
patched only BSP core leaving APs unpatched and AGESA was overwriting the patch
with its own microcode in one of initialization phases.

Thus we have redesigned the feature to overwrite the microcode patch.

## User guide

To build the firmware from scratch and add microcode patch follow the
steps:

1. Clone the [pce-fw-builder](https://github.com/pcengines/pce-fw-builder)
2. Pull or [build](https://github.com/pcengines/pce-fw-builder#building-docker-image)
    docker container:

    ```
    docker pull pcengines/pce-fw-builder
    ```

    or for legacy:

    ```
    docker pull pcengines/pce-fw-builder-legacy
    ```

3. Build v4.8.0.7 image (v4.0.22 for legacy):

    ```
    ./build.sh release v4.8.0.7 {apu2|apu3|apu4|apu5}
    ```

4. Download the [microcode patch](https://github.com/platomav/CPUMicrocodes/raw/master/AMD/cpu00730F01_ver07030106_2018-02-09_88EDFAA0.bin)
    and place it in `release/coreboot` which is relative to cloned `pce-fw-builder`
    directory.

4. Make changes to menuconfig:

    ```
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4|apu5} menuconfig
    ```

    In the Chipset submenu find `Include CPU microcode in CBFS` and choose
    `Add microcode patch for AMD fam16h (EXPERIMENTAL)` option. Then in the
    Chipset submenu fill the `Microcode binary path and filename` field with
    `cpu00730F01_ver07030106_2018-02-09_88EDFAA0.bin` which was downloaded in
    previous step. If the binary has been renamed, please fill the renamed binary
    here. Path is relative to coreboot root directory. When finished, save the
    config file.

5. Build the image again:

    ```
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4|apu5} CPUS=$(nproc)
    ```

6. Flash the new image. The firmware image can be found in
    `release/coreboot/build` which is relative to cloned `pce-fw-builder`
    directory.


## Summary

By default the microcode patch level is `0x07030105` according to dmesg reports
on Linux system. So v4.8.0.7 release binary will show:

```
microcode: CPU0: patch_level=0x07030105
microcode: CPU1: patch_level=0x07030105
microcode: CPU2: patch_level=0x07030105
microcode: CPU3: patch_level=0x07030105
```

After successfully building and flashing the image, dmesg should show:

```
microcode: CPU0: patch_level=0x07030106
microcode: CPU1: patch_level=0x07030106
microcode: CPU2: patch_level=0x07030106
microcode: CPU3: patch_level=0x07030106
```

Also when checking the vulnerability status with [spectre-meltdown-checker](https://github.com/speed47/spectre-meltdown-checker)
one can notice that following fields have changed:

With microcode patch:

```
* PRED_CMD MSR is available:  YES
* CPU indicates IBPB capability:  YES  (IBPB_SUPPORT feature bit)
...
* IBPB enabled and active:  YES
```

Without microcode patch:

```
* PRED_CMD MSR is available:  NO
* CPU indicates IBPB capability:  NO
...
* IBPB enabled and active:  NO
```

> Load `msr` kernel module before launching the script.

