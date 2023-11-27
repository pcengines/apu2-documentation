pfSense Installation Guide
===========================

## Contents

<!-- TOC -->

- [pfSense Installation Guide](#pfsense-installation-guide)
    - [Contents](#contents)
    - [pfSense Image](#pfsense-image)
    - [Booting installer](#booting-installer)
    - [Installation](#installation)

<!-- /TOC -->


## pfSense Image

In order to install pfSense on apu2/3/5 platforms from USB, obtain following
[Image](https://sgpfiles.netgate.com/mirror/downloads/pfSense-CE-memstick-serial-2.7.1-RELEASE-amd64.img.gz)
from official mirror and follow the official
[Writing Disk Images](https://docs.netgate.com/pfsense/en/latest/hardware/writing-disk-images.html) guide for
Windows, Linux, UNIX or MAC OS X.

## Booting installer

Plug the USB stick prepared earlier to apu and boot from it.

Only for BIOS v4.6.7 or older, when main installer menu pops up do the following:

- Interrupt the installer by pressing `ESC` and type
  following commands:

  ```
  set hint.ahci.0.msi="0"
  boot
  ```

> BIOS versions v4.6.7 and older need to have MSI disabled, due to signal races
> causing disk write commands timeouts.

Installer should load the kernel now and begin installation process.

## Installation

Proceed with the installation choosing the options that fit you.

At the end of installation, only BIOS v4.6.7 or older to prevent system hangs or reboots
after few hours uptime, open the shell to customize the system:

Edit `/boot/device.hints` and append `hint.ahci.0.msi="0"`
