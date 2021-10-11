J13 USB header enablement
===============================

## J13 USB header

The J13 USB header found on apu3-6 boards is disabled by default in some BIOS
versions. If you encounter problems with USB peripherals (e.g. watchdog module)
connected to this header, you may use `sortbootorder` to enable the EHCI
controller functionality.

## How to enable

- Enter sortbootorder in the SeaBIOS menu while booting by choosing the option
  `payload [setup]` in the boot menu
- Check the state of the EHCI controller - if it says `Disabled`, enable it
  using the `H` key
- Save and exit sortbootorder by pressing `s`.
