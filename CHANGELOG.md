Change log for PC Engines binary releases
=========================================

This document contain changelog for binary releases that contain all below
components:

* [coreboot (with all required blobs)](https://github.com/pcengines/coreboot)
* [SeaBIOS](https://github.com/pcengines/seabios)
* [sortbootorder](https://github.com/pcengines/sortbootorder)
* [ipxe](https://github.com/pcengines/ipxe)
* [memtest86+](https://github.com/pcengines/memtest86plus)

Releases 4.0.x are based on PC Engines 20160304 release.
Releases 4.5.x are based on mainline support submitted in 
[this gerrit ref](https://review.coreboot.org/#/c/14138/).

## [Unreleased]

## [v4.0.3] - 2016-12-14
- [coreboot v4.0.3]()
- [SeaBIOS rel-1.9.2.2]()
- [sortbootorder v4.0.2]()
- [ipxe v4.0.1]()
- [memtest86+ v4.0.1]()

## [v4.0.2] - 2016-12-09
- [coreboot v4.0.2]()
- [SeaBIOS rel-1.9.2.1]()
- [sortbootorder v4.0.2]()
- [ipxe v4.0.1]()
- [memtest86+ v4.0.1]()

## [v4.0.1.1] - 2016-09-12
- [coreboot v4.0.1.1]()
- [SeaBIOS rel-1.9.2.1]()
- [sortbootorder v4.0.1]()
- [ipxe v4.0.1]()
- [memtest86+ v4.0.1]()

## [v4.0.1] - 2016-09-12
- [coreboot v4.0.1]()
- [SeaBIOS rel-1.9.2.1]()
- [sortbootorder v4.0.1]()
- [ipxe v4.0.1]()
- [memtest86+ v4.0.1]()

### iPXE

mirror of [iPXE git tree](http://git.ipxe.org/ipxe.git)

Mainline releases
-----------------

## [v4.5.3]
### coreboot
#### Added
- support for legacy LEDs behavior
- legacy logs at boot
- 4k alignment for bootorder in CBFS

#### Changed
- enabled memtest86+ by default

#### Fixed
- incorrect GPIO implementation

### sortbootorder
#### Fixed
- problem with saving configuration

### SeaBIOS
#### Changed
- limit level 1 logs to minimum

## [v4.5.2]
### coreboot
#### Added
- port of clock settings from legacy implementation
- support for getting sku and serial number
- sortbootorder as secondary payload
- PXE ROM based on 2016.7 release

#### Changed
- log level to ALERT
- enable UART C and UART D by default

#### Fixed
OSes tested: Debian testing (Linux kernel 4.8) and Voyage Linux (APU2 image 
builder)
- booting from start works fine (Seagete SSHD 1TB ST1000LM014)
- USB booting works fine (USB MSC Drive UFD 3.0 Silicon-Power16G 1100)
- iPXE works fine (tested with Debian netboot pxelinux.0)
- HDD warm and cold boot works (Seagete SSHD 1TB ST1000LM014)
- USB warm and cold boot works (USB MSC Drive UFD 3.0 Silicon-Power16G 1100)
- iPXE works fine (tested with Debian netboot pxelinux.0)

### sortbootorder
#### Fixed
- compilation fixes to build with mainline coreboot

## [v4.5.1]
#### Added
- mainline support for APU2

## [v4.0.1.1]
### coreboot
#### Changed
- Reprogrammed `GPP_CLK3` output (connected to miniPCIe slot 1) to ignore 
`CLKREQ#`
    input - forced it to be always on.

