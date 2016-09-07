PC Engines APU2 Coreboot Release Notes
--------------------------------------

### 4.0.1

#### Coreboot & SeaBIOS

  * introduce versioning
  * obtain `smbios` fields, such as `board serial` and `SKU`
  * allow for one-time `PXE ` boot with `N` key
  * reduce log level: display mainboard, DRAM and ECC info only
  * improve SD card performance
  * force to use SD in 2.0 mode
  * prevent from printing character multiple times
  * nct5104d driver backport
  * check if `git` exists before calling it
  * change git repository in `Makefile`
  * add missing `cbfs_find_string` in `libpayload`
  * add missing binaries
  * add executable bit to `xcompile`
  * U-ELTAN release 20160304

#### Sortbootorder

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
    [apu1coreboot_140908](http://pcengines.ch/tmp/coreboot_140908.tar.gz)


