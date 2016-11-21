PC Engines APU2 coreboot Release Notes
--------------------------------------

Releases 4.0.x are based on PC Engines 20160304 release
Releases 4.5.x are based on mainline support submitted in [this gerrit ref](https://review.coreboot.org/#/c/14138/)

### 4.5.2

#### coreboot

  * port of clock settings from legacy implementation
  * support for getting sku and serial number
  * set log level to ALERT
  * add sortbootorder as secondary payload
  * include PXE ROM based on 2016.7 release
  * enable UART C and UART D by default
  * booting from start works fine (Seagete SSHD 1TB ST1000LM014)
  * USB booting works fine (USB MSC Drive UFD 3.0 Silicon-Power16G 1100)
  * iPXE works fine (tested with Debian netboot pxelinux.0)

#### sortbootorder

  * compilation fixes to build with mainline coreboot

### 4.5.1

#### coreboot

  * mainline support for APU2

### 4.0.1.1

#### coreboot

  * Reprogram `GPP_CLK3` output (connected to miniPCIe slot 1) to ignore `CLKREQ#`
    input - force it to be always on.

### 4.0.1

#### coreboot

  * introduce versioning
  * obtain `smbios` fields, such as `board serial` and `SKU`
  * reduce log level: display mainboard, DRAM and ECC info only
  * improve SD card performance
  * force to use SD in 2.0 mode
  * nct5104d driver backport
  * check if `git` exists before calling it
  * change git repository in `Makefile`
  * add missing `cbfs_find_string` in `libpayload`
  * add executable bit to `xcompile`

#### SeaBIOS

  * allow for one-time `PXE ` boot with `N` key
  * enable/disable `USB` boot
  * enable/disable `PXE` boot
  * prevent from printing character multiple times

#### sortbootorder

  * merge all `USB` entries into one
  * add `(disabled)` tag in menu
  * interface modification
  * version bump to v1.3
  * add `PXE` and `USB` enable options in menu
  * add `PXE` to bootorder menu
  * change interface to lower case
  * version bump to v1.2
  * change letter for save and exit to `S`
  * use proper way to access extended SPI registers
  * add support for `yangtzee fch spi controller`
  * user interface improvements
  * add `PC Engines` header
  * add `README` and `Makefile`
  * initial commit based on
    [coreboot_140908](http://pcengines.ch/tmp/coreboot_140908.tar.gz)

#### Memtest86plus

  * add macro `SPD_DISABLED ` for disabling SPD related functionality
  * fix refresh procedure so that full screen content is reprinted on refresh
  * add refresh option label (`l`) to bottom menu
  * enable serial console by default
  * based on [memtest86plus](https://review.coreboot.org/cgit/memtest86plus.git?)

#### iPXE

  * mirror of [iPXE git tree](http://git.ipxe.org/ipxe.git)
