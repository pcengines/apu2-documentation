Serial console output in coreboot
=================================

Along with v4.8.0.6 and v4.0.21 we introduced possibility to enable COM2 as the
main serial port for serial console output in coreboot and SeaBIOS. Because this
is not enabled in runtime configuration, separate binary must be built in order
to get the output on COM2.

Since releae v4.8.0.7 and v4.0.22 output redirection to COM2 became possible via
runtime configuration. Supported sortbootorder and SeaBIOS versions are v4.6.12
and rel-1.11.0.7 respectively. For details see [COM2 runtime configuration](#com2-runtime-configuration)

## Building coreboot firmware with console on COM2

Building image capable of printing output on COM2 is relatively easy.

### Users guide

To build the firmware from scratch and change the output to COM2 follow the
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

3. Build v4.8.0.6 image (v4.0.21 for legacy):

    ```
    ./build.sh release v4.8.0.6 {apu2|apu3|apu4}
    ```

4. Make changes to menuconfig:

    ```
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4} menuconfig
    ```

    In order to change serial port, go to Console menu and change
    `Index for UART port to use for console` to `1`. You will see that comment
    below `*** Serial port base address = 0x3f8 ***` will change to
    `*** Serial port base address = 0x2f8 ***` (this comment is not displayed in
    legacy). Then go to Payload menu and type the changed serial port base address
    (`0x2f8`) to `SeaBIOS sercon-port base address`  field. Now save new config.

    For legacy it may not build the firmware with expected changes. One has to do
    a distclean first, copy the config and make the changes again:

    ```
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4} distclean
    cp $PWD/release/coreboot/configs/pcengines_{apu2|apu3|apu4}.config  $PWD/release/coreboot/.config
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4} menuconfig
    ```

5. Build the image again:

    ```
    ./build.sh dev-build $PWD/release/coreboot {apu2|apu3|apu4} CPUS=$(nproc)
    ```

6. Flash the new image with serial output on COM2. The firmware image can be
    found in `release/coreboot` which is relative to cloned `pce-fw-builder`
    directory.

### Developers guide

Make default config for platform and then run menuconfig:

```
cp configs/config.pcengines_apux .config
make olddefconfig
make menuconfig
```

> `make olddefconfig` step is valid only on mainline. For legacy releases, omit
> this step

In order to change serial port, go to Console menu and change
`Index for UART port to use for console` to `1`. You will see that comment
below `*** Serial port base address = 0x3f8 ***` will change to
`*** Serial port base address = 0x2f8 ***` (this comment is not displayed in
legacy). Then go to Payload menu and type the changed serial port base address
(`0x2f8`) to `SeaBIOS sercon-port base address`  field. Now save new config.

### COM2 runtime configuration

Since v4.8.0.7 and v4.0.22, sortbootorder has a new option to enable output
redirection to COM2. After entering sortbootorder menu, one could notice
additional COM2 redirection among other options:

```
  u USB boot - Currently Enabled
  t Serial console - Currently Enabled
  k Redirect console output to COM2 - Currently Disabled
  o UART C - Currently Enabled
  p UART D - Currently Enabled
```

Pressing `k` and savign changes will cause switching output to COM2. The change
affects coreboot, SeaBIOS, sortbootorder and iPXE. Unfortunately redirection
doesn't work for memtest86+. Memtest86+ has no possibility to redirect console
to other port than specified during build process. If one wishes to have full
support for COM2, follow [Users guide](#users-guide) to build firmware from
scratch.

> NOTE: when building firmware from scratch for COM2 as described in
> [Users guide](#users-guide), there will be no going back to COM1, even when
> COM2 redirection is disabled in sortbootorder. One will have to flash firmware
> with COM1 as main serial port (release bianry for example).

## Summary

By default main console is COM1 with base address of `0x3f8`. This is the base
address of ttyS0 typically. After changing the output to COM2, do not forget to
adjust kernel cmdline in Your OSes to set console to ttyS1 (base address
`0x2f8`). The baud rate remains the same (115200).

The serial console disable feature in sortbootorder works also for COM2. So if
one does not desire to have output in firmware, it can be simply turned off (and
turned back again with S1 button).

COM2 redirection runtime configuration works properly with all payloads except
memtest86+. Serial port configuration for memtest86+ is determined during build
and it cannot be changed by any means in firmware.
