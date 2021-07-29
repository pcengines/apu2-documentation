# Offline tool for bootorder modifications

This document describes requirements for [offline tool for coreboot's runtime configuration](https://github.com/pcengines/coreboot/issues/308)
and lists possible options for implementation. Such tool is desired for two
major reasons:
- saving configuration before and restoring after flashing new version of
  coreboot,
- changing configuration without need for serial connection.

Both of those functionalities are especially useful for administrating off-site
devices without need for physical presence.

#### General requirements
- compatibility with Linux and BSD
- ability to print current settings and boot order
- ability to shuffle the boot order
- ability to toggle the feature options
- ability to operate offline on the raw binary
- ability to save and reload settings from backup file
- CLI interface

###### Optional requirements
- ability to operate on the flash directly
  - greatly complicates implementation and requires root access
  - depends heavily on OS used
- GUI
  - apu devices are headless, but the image may be prepared on a PC before
    flashing
  - GUI and direct operation on flash won't be used simultaneously, there is
    nothing to be gained by putting both enhancements in one binary

#### Bootorder file format

The default bootorder file can be found in [apu2 mainboard directory](https://github.com/pcengines/coreboot/blob/release/src/mainboard/pcengines/apu2/bootorder_def).
This is a text file with lines separated with a DOS/Windows newline ('\r\n').
A copy of this file is saved in CBFS as `bootorder_def` - this is what `r` key
in sortbootorder payload restores to. Lines starting with '/' are boot devices,
those listed at the top have higher boot priority. All devices are listed, even
if the disabled ones.

Boot entries are followed by configurable options. They have a format of text
token followed by a number. Usually this is either 0 or 1 for disabled and
enabled state respectively, but `watchdog` option has 4 hexadecimal digits to
hold the timeout value. The order of those fields doesn't matter.

Another file is [bootorder_map](https://github.com/pcengines/coreboot/blob/release/src/mainboard/pcengines/apu2/bootorder_map),
which pairs keys used to select given boot option to move it to the top with
their underlying device paths. It also provides user readable labels for those
devices which are printed by the payload. These are the only strings which are
printed by `sortbootorder` from any file, the rest of them is coded in the
payload itself.

The last and most important file is `bootorder`. This file is generated during
coreboot build from `bootorder_def` - it is an exact copy, except it is padded
to 4K with zeros and text message at the end: `this file needs to be 4096 bytes
long in order to entirely fill 1 spi flash sector`. It is also aligned to 4K so
this file can be flashed without overwriting other files.

## Option 1 - modification of existing sortbootorder payload

In this option existing [sortbootorder payload](https://github.com/pcengines/sortbootorder)
is expanded with executable files for running under OS.

#### Pros:
- changes are easy to maintain, limited to one repository
- uses the same menu layout as in payload
- can reuse parts of libpayload (e.g. CBFS parsing)
- has functions for SPI access
- possibly can be made to work with minimal modifications

#### Cons:
- complicates build system
- need to reimplement some of libpayload's functionality
- CLI only, implemented in form that is hard to modify
- current code assumes unlimited access to the hardware
  - physical addressing
  - unlimited I/O access, with no other entities using it concurrently
  - this probably implies running the tool as privileged user

#### Code dependencies that must be resolved

External functions and symbols used by sortbootorder:
- main file, obtained with `objdump sortbootorder.o -t | grep UND`:
  - getchar, printf, str* etc. - from libpayload/libc.a, but can use standard C
    library instead
  - cbfs_get_file_content and cbfs_get_handle - from libpayload/libcbfs.a
  - lib_get_sysinfo, lib_sysinfo - from libpayload/libc.a
    - used only for board name in banner
- utils (`objdump utils/*.o -t | grep UND`, excluding symbols found in different
  compilation units in the same directory):
  - readline, atol, printf, str* - standard C library (readline is not standard
    C, GNU extension?)
  - spi_flash_cmd, spi_flash_cmd_write, spi_flash_probe - from sortbootorder/spi
- spi (`objdump spi/*.o -t | grep UND`, excluding symbols found in different
  compilation units in the same directory):
  - malloc (but no free?), memcpy, memset, printf - standard C library
  - arch_ndelay - from libpayload/libc.a, most likely other, OS-specific
    functions exist, but this would **need implementing in sortbootorder**
  - pci_read_config32 - from libpayload/libpci.a

External dependencies of libpayload's libraries:
- libcbfs
  - can add custom version of cbfs_media, i.e. port ram_media.c to use file
    operations (fopen, fread etc.) instead
    - this file may be OS-specific
    - may live in sortbootorder repo and just be linked with libcbfs
  - list of external functions called and other symbols:
    - memcpy, memcmp, memset, strcmp, malloc, free, printf - from libc
    - ulz4fn, ulzman - decompression utils, not used for bootorder file but
      probably required for linking - from liblzma and liblz4
    - init_default_cbfs_media, libpayload_init_default_cbfs_media - arch
      specific, used only when cbfs_media is NULL in calls
    - lib_sysinfo - struct with platform data, mostly from parsing coreboot
      tables, used only when cbfs_media is NULL in call to get_cbfs_range
- liblz4, liblzma
  - depend only on standard C functions, can be linked without too many issues
- libpci
  - this implementation accesses PCI through 0xCF8/0xCFC pair, which may and
    should be blocked by OS
  - needs OS-specific functions to access PCI without getting in the way of
    kernel

**WARNING: libpayload and sortbootorder are built for 32 bits, some of their
functions may not work in 64 bits out of the box.**

#### Implementation details
- reading options from file can be as easy as using different file in place of
  `bootorder_def` and forcing `r` command (Restore boot order defaults)
- saving options to file can be implemented as writing to new file instead of
  (or in addition to) writing to flash
- reading from flash mapped just below 4G requires mmapping, userspace tool uses
  virtual addressing
- reading from and writing to flash binary (either read by `flashrom` or new
  release downloaded from the web) needs to be implemented from scratch
- tool cannot reboot the platform in the same way as payload did

## Option 2 - full rewrite of whole application

This option assumes that a whole new application is developed, one which
searches for `bootorder` file in flash or binary image, reads and modifies it
and writes it back to SPI or file.

#### Pros:
- can be integrated better with target OS
- possible to design GUI
- better integration of required access to the hardware

#### Cons:
- lots of work
- options added later to payload version would have to be ported to new tool and
  vice versa
- can't easily reuse interfaces provided by libpayload
- high probability of different versions required for different OSes
- requires implementation of SPI access functions
- tool requires root access for hardware operations
- currently most of text is hardcoded in `sortbootorder` payload

#### Implementation details
- everything would have to be developed from scratch
- access to files in both BSD and Linux can be done in the same way (POSIX)
- access to flash is OS-specific
- re-designing CBFS access functions requires some knowledge of coreboot
- SPI access requires both knowledge about SPI flash vendors' implementations
  and low level access to the hardware in the OS
- `bootorder` must be padded and aligned to 4K in order for `sortbootorder` to
  work

## Option 3 - using existing userspace applications for low lever operations

In this variant a minimal application is developed that modifies `bootorder` and
depends on `flashrom` to read and write flash and `cbfstool` to parse and update
CBFS image.

#### Pros:
- no need to implement what is already done in other utilities
  - hardware access done by flashrom
  - CBFS parsing performed by cbfstool
- new code will be smaller than for other options
- may use GUI
- doesn't have to be written in C
- tool can be run with user privileges, only `flashrom` requires direct access
  to hardware

#### Cons:
- users will need to install or compile multiple tools
- may be hard to keep up with changes to bootorder layout
- currently most of text is hardcoded in `sortbootorder` payload

#### Implementation details
- scripts for reading and writing back `bootorder` either from/to flash or
  binary file have to be developed
- configuration file is simple text file so can be parsed in virtually all
  programming languages
  - remember about DOS newline characters when writing or use `unix2dos`
  - padding to 4K may need some trickery
- `cbfstool` must be told to align new `bootorder` file appropriately
