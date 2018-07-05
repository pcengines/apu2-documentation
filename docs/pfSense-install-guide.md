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
[Image](https://sgpfiles.pfsense.org/mirror/downloads/pfSense-CE-memstick-serial-2.4.2-RELEASE-amd64.img.gz)
from official mirror.

Extract the image somewhere and burn it onto usb stick using `dd`:

```
dd if=pfSense-CE-memstick-serial-2.4.2-RELEASE-amd64.img of=/dev/sdx status=progress
```

where `sdx` is the correct USB drive.

> On BIOS v4.6.4 or newer and v4.0.14 or newer one will have to deal with double
> console redirection in newer BIOSes due to multiconsole option in installer.
> In the [Installation section](#installation) there is a description how to fix
> it. If one has a write access to the stick, just edit `/boot.config` to
> `-S115200 -h` and in `/boot/loader.conf` change
> `console="comconsole,vidconsole"` to `console="comconsole"` before booting
> pfSense for the first time. Append `hint.ahci.0.msi="0"` to
> `/boot/device.hints` file. Also it is good to change
> `/boot/defaults/loader.conf`:
>
> - change `#boot_serial=""` to `boot_serial="YES"`
> - change `#comconsole_speed="9600"` to `comconsole_speed="115200"`
> - change `#console="vidconsole"` to `console=comconsole`
>
> Already prepared image is available at [3mdeb cloud](https://cloud.3mdeb.com/index.php/s/I36WY5x8pDcTd9y)

## Booting installer

Plug the USB stick prepared earlier to apu and boot from it.

When main installer menu pops up do the following:

- for BIOS v4.0.x let it boot automatically
- for BIOS v4.6.7 or older, interrupt the installer by pressing `ESC` and type
  following commands:

  ```
  set hint.ahci.0.msi="0"
  boot
  ```

> BIOS versions v4.6.7 and older need to have MSI disabled, due to signal races
> causing disk write commands timeouts. This issue is not present in legacy
> BIOSes v4.0.x. Do it now if did not edit `/boot/device.hints` earlier.

Installer should load the kernel now and begin installation process.

## Installation

Proceed with the installation choosing the options that fit you.

At the end of installation open the shell to customize the system:

> Only for installation on BIOS v4.6.4 or later and v4.0.14 or later

```
echo "-S115200 -h" > /boot/config
rm /boot.config
ln /boot/config /boot.config
```

> It is necessary to create hardlink, because /boot.config seems to not be
> persistent between boots.

Copy `/boot/loadef.conf` and name it as `/boot/loadef.conf.local`.

```
cp /boot/loader.conf /boot/loader.conf.local
```

Open `/boot/loadef.conf.local`, change `console="comconsole,vidconsole"` to
`console="comconsole"` and delete `boot_multicons="YES"` line.

> This is needed for BIOS v4.6.4 or newer and v4.0.14 or newer to avoid doubled
> output in loader.

Also append `hint.ahci.0.msi="0"` on BIOS v4.6.7 or older to
prevent system hangs or reboots after few hours uptime.

Edit `/boot/defaults/loader.conf`:
- change `#boot_serial=""` to `boot_serial="YES"`
- change `#comconsole_speed="9600"` to `comconsole_speed="115200"`
- change `#console="vidconsole"` to `console=comconsole`
- change `loader_conf_files="/boot/device.hints /boot/loader.conf /boot/loader.conf.local"`
  to `loader_conf_files="/boot/device.hints /boot/loader.conf.local"`

