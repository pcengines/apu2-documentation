Serial console output in coreboot
=================================

Along with v4.8.0.6 and v4.0.21 we introduced possibility to enable COM2 as the
main serial port for serial console output in coreboot and SeaBIOS. Because this
is not enabled in runtime configuration, separate binary must be built in order
to get the output on COM2.

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
  ./build.sh dev-build $PWD/release/coreboot apux menuconfig
  ```

  In order to change serial port, go to Console menu and change
  `Index for UART port to use for console` to `1`. You will see that comment
  below `*** Serial port base address = 0x3f8 ***` will change to
  `*** Serial port base address = 0x2f8 ***` (this comment is not displayed in
  legacy). Then go to Payload menu and type the changed serial port base address
  (`0x2f8`) to `SeaBIOS sercon-port base address`  field. Now save new config.

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

## Summary

By default main console is COM1 with base address of `0x3f8`. This is the base
address of ttyS0 typically. After changing the output to COM2, do not forget to
adjust kernel cmdline in Your OSes to set console to ttyS1. The baud rate
remains the same (115200).

The serial console disable feature in sortbootorder works also for COM2. So if
one does not desire to have output in firmware, it can be simply turned off (and
turned back again with S1 button).