Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
apuX platform users and developers to customize firmware to their needs.

- [Repository structure](#repository-structure)
  - [Useful documents](#useful-documents)
- [Versioning scheme change](#versioning-scheme-change)
  - [Why we changed versioning scheme?](#why-we-changed-versioning-scheme)
  - [Why we skipped coreboot 4.7?](#why-we-skipped-coreboot-47)
  - [Binary releases](#binary-releases)
  - [Building firmware using PC Engines firmware builder](#building-firmware-using-pc-engines-firmware-builder)
  - [Branch description](#branch-description)
- [Feature/bug fix development](#featurebug-fix-development)
- [Steps for new release](#steps-for-new-release)
- [Using iPXE](#using-ipxe)
  - [Known issues](#known-issues)
    - [Board mismatch](#board-mismatch)
  - [Contribute](#contribute)

# Repository structure

This repository aims to gather all debug notes and documentation related to
PC Engines apu1/2/3/4/5 firmware and hardware. Structure of the repository:

- [configs](configs) - directory with kernel configs used in 3mdeb pxe-server
  for validation purposes
- [docs](docs) - overall directory with documents
  - [docs/debug](docs/debug) - documents containing various problems debugging
    notes
  - [docs/images](docs/images) - images included in certain documents
  - [docs/logs](docs/logs) - directory containing variosu logs from debugging
  - [docs/research](docs/research) - directory with notes from research of new
    features
- [ipxe](ipxe) - iPXE scripts, headers and configuration files used in old
  build system
- [scripts](scripts) - BASH scripts used in the old build system

## Useful documents

- [Fast Boot](docs/research/fast_boot.md) - document describing research for
  Fast Boot path for apu boards. The Fast Boot was intended to restore memory
  configuration from non-volatile storage and reduce the boot time of the
  platform. You will find the issues and limitations which did not allow to
  implement the feature.

- [ROCA](docs/research/ROCA.md) - document describing ROCA TPM vulnerablity
  status and verification on TPM1a module form PC Engines.

- [APU mPCIe capabilities](docs/APU_mPCIe_capabilities.md) - list of all
  signals and interfaces present on mPCIe connectors for apu2/3/4 boards.
  The document also describes possible usage of the slots.

- [Cold reset](docs/cold_reset.md) - document describing reset types for the
  platform.

- [Firmware flashing](docs/firmware_flashing.md) - document describes how to
  flash new firmware for apu2 board on various operating systems. Also there is
  a description how to safely reboot the platform after a firmware update.

- [Microcode patching](docs/microcode_patching.md) - a guide how to apply
  a microcode patch on the firmware level by building a custom firmware image.

- [mPCIe modules](docs/mpcie_modules.md) - list of supported and tested WiFi
  and LTE modules. The document also describes issues with certain modules and
  possible solutions/workarounds.

- [pfSense installation guide](docs/pfSense-install-guide.md) - as in the title

- [PXELINUX configuration](docs/pxelinux-cfg.md) - documents describing
  possible solutions when experiencing problems with PXELINUX on apu boards.

- [Old build system procedure (deprecated)](docs/release_process.md) - document
  describing build procedure for older PC Engines firmware releases. It is
  deprecated, do not use unless You want to build old binaries.

- [COM2 serial console](docs/serial_console.md) - a practical guide how to
  build a firmware binary with native COM2 console support. If You want to use
  full RS232 COM1 port for other purposes, read the document how to change the
  main console port.

- [TPM menu](docs/tpm_menu.md) - document describes the usage of TPM
  configuration menu in SeaBIOS.

- [TPM pin mapping](docs/tpm_pin_mapping.md) - document showing the TPM1a
  module pinout. It may be useful for users that would like to connect the
  TPM1a module to boards other than apu2.

- [VBOOT HOWTO](docs/apu2_vboot.md) - document describing hwo to build a
  coreboot image with vboot support and measured boot mode

You may also find many other documents out there, but we have listed only the
most useful. Other are mostly developers notes which may not be that
interesting.

Versioning scheme change
========================

Since version `v4.8.0.1` we changed versioning scheme skipping coreboot `v4.7`
release.

## Why we changed versioning scheme?

In recent version coreboot community introduced tag `v4.8.1` this breaks our
previous versioning scheme which was `v4.6.z`, where `z` was PC Engines fork
patch number. Because 3rd digit was already taken by coreboot tag this breaks
our versioning scheme. As a result we start to use new versioning scheme
`v4.8.0.w`, where `w` will be PC Engines fork patch number as always for each
new release counted from 0.

## Why we skipped coreboot 4.7?

If you take a look at coreboot tag dates:

```
refs/tags/4.6 Sun Apr 30 19:48:38 2017 -0600
refs/tags/4.7 Mon Jan 15 00:57:04 2018 +0000
refs/tags/4.8 Tue May 15 17:40:15 2018 +0000
refs/tags/4.8.1 Wed May 16 19:07:34 2018 +0000
```

After release of 4.7 we simply didn't have enough time to adjust to 4.7 before
4.8 popped up. Please note that coreboot releases are just arbitrary points in
time, so trying to follow mainline in each release may make more sense, but
requires decent testing.

Binary releases
---------------

All information about firmware releases (including changes, fixes and known
issues) are available on the PC Engines Github site [pcengines.github.io](https://pcengines.github.io/).

All the newest binaries can be found there.

Also please take a look at changelogs:

* [v4.6.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.6.x/CHANGELOG.md)
* [v4.5.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.5.x/CHANGELOG.md)
* [v4.0.x changelog](https://github.com/pcengines/release_manifests/blob/coreboot-4.0.x/CHANGELOG.md)

Building firmware using PC Engines firmware builder
---------------------------------------------------

Since releases v4.6.10 and v4.0.17 build process has been simplified.
PC Engines firmware builder is a dedicated tool to build fully featured apu
firmware binaries using separated docker environment. It provides users-friendly
scripts that allow to build release and custom binaries. For more information
and usage details please visit: [pce-fw-builder](https://github.com/pcengines/pce-fw-builder).

For releases older than v4.0.17 and v4.6.10 use the procedure described in this
[document](docs/release_process.md)

Branch description
------------------

* `master` - keeps track of [coreboot's master branch](https://review.coreboot.org/cgit/coreboot.git/log/)
* `release` - where all releases are merged
* `develop` - where current development takes place periodically synced with
  coreboot master
* `rel_x.y.z.w` - release branches, where:
    * `x` is coreboot major version
    * `y` is coreboot minor version
    * `z` is coreboot patch number
    * `w` is PC Engines firmware fork patch number counted from `0`
* `feature_branch` - sample feature branch name for workflow explanation needs

# Feature/bug fix development

We are in favor of [Test Driven Bug Fixing (TDBF)](https://geeknarrator.com/2018/01/28/test-driven-bug-fixing-guidelines/).

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Pull `coreboot's master branch` to `master`
3. Merge `master` to `develop`
4. Create new branch `feature_branch` from `develop`
5. Commit changes to `feature_branch`
6. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
7. Submit PR to `develop`

# Steps for new release

1. Checkout new branch `rel_x.y.z.w` from recent commit on `release`
2. Merge current `develop` to `rel_x.y.z.w`
3. End of month we close merge window
4. Perform automated regression testing on `rel_x.y.z.w` including all new
   tests
5. Fix all required issues and repeat point 4 until fixed - this doesn't mean
   all tests pass, this mean that approved set passed
6. If results are accepted merge it to `release` branch
7. Add tag, which should trigger CI and publish binaries
8. Merge release branch to develop

# Using iPXE

This option assume that your apuX is in the same networks as your PC. Your PC
in this case is used as HTTP and NFS server, which will be utilized to boot
apuX over iPXE.

```
git clone https://github.com/3mdeb/pxe-server.git
cd pxe-server
NFS_SRV_IP=<your_ip> ./init.sh
./start.sh
```

Please note that you may have NFS server running on host what leads to ports
conflicts.

After starting NFS and HTTP you can boot apuX. Please enable network booting
using [sortbootorder](https://github.com/pcengines/sortbootorder#theory-of-operation).

```
iPXE> ifconf net0
iPXE> dhcp net0
iPXE> chain http://<your_ip>:8000/menu.ipxe
```

Choose `Debian stable netboot 4.14.y` after boot login (`[root:debian]`) and
for apu2/3/4/5 run:

```
flashrom -p internal -w apuX_x.y.z.rom
```

For apu1 `flashrom` command line looks like that:

```
flashrom -p internal -w apu1_x.y.z.rom -c MX25L1605A/MX25L1606E/MX25L1608E
```

A full power cycle is required after flashing. See [firmware_flashing.md](docs/firmware_flashing.md#corebootrom-flashing)
for a workaround when this is not possible (e.g. when upgrading remotely).

## Known issues

### Board mismatch

Some binaries may need `boardmismatch=force` flashrom option because of SMBIOS
table issue we had in old releases. Please double check you flashing correct
binary before forcing.

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
