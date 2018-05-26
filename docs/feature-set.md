PC Engines apu feature set
==========================

## Coreboot features

| Feature | Supported |
|---------|-----------|
| CBFS option mCPIe2 clk| YES |
| CBFS option EHCI0 | YES |
| CBFS option console | YES |
| CBFS option UARTc/d | YES |
| Serial number from NIC | YES |
| Serial number from SPI flash | YES |
| S1 button | YES(1) |
| SATA AHCI | YES(2) |
| Serial console enable/disable | YES(3) |
| SIMSWAPs | YES(4) |
| SMBIOS table short partnumber | YES |

1) - apu5 has no support for S1
2) - only mainline releases
3) - apu5 support only disable option, S1 button not supported yet
4) - apu3 seems to have inverted functionality

# SeaBIOS features

| Feature | Supported |
|---------|-----------|
| OHCI/UHCI disabled | YES |
| ATA UDMA | YES |
| Boot menu timeout 6s | YES |
| F10 button to enter boot menu | YES |
| Custom boot menu string | YES |
| N for iPXE boot string | YES |
| Hiding iPXE rom | YES |
| USB boot enable/disable | YES |
| USB xHCI timing adjustments | YES(1) |
| Serial console enable/disable | YES(2) |
| Bootorder configuration file | YES |
| Sercon-port configuration file | YES |

1) - some sticks seem to not work still, additionally apu4 has problems with
two sticks simultaneously plugged
2) - apu5 do not yet support serial console enable

# iPXE features

| Feature | Supported |
|---------|-----------|
| Output not duplicated | YES |
| Custom iPXE menu | YES |

# Memtest86+ features

| Feature | Supported |
|---------|-----------|
| Correct SMBus base | YES(1) |
| Screen refresh | YES |

1) - SMBus base is correct for apu2 series, Memtest86+ hangs on apu1

# Sortbootorder features

| Feature | Supported |
|---------|-----------|
| Setting bootorder priority | YES |
| PXE boot enable/disable | YES |
| USB boot enable/disable | YES |
| Serial console enable/disable | YES |
| UARTc/d enable/disable | YES |
| Force mPCIe2 clk | YES |
| BIOS WP enable/disable | YES |
| Restore default options | YES |
| EHCI0 enable/disable | YES |
| Bootorder is aligned correctly | YES |
| Security registers | YES(1) |

1) - locking OTP registers seems to not work

# Operating systems and medias

| OS | Netboot NFS |
|----|-------------|
| Debian 4.14.y | YES |
| Debian 4.15.y | YES |
| Debian 4.16.y | YES |
| CoreOS stable | YES(tmpfs) |
| pfSense 2.4.3 | not tested |
| pfSense 2.3.5 | not tested |
| OpenWrt | not tested |
| OPNSense | not tested |
| NetBSD | not tested |
| FreeBSD | not tested |
| OpenBSD | not tested |

| OS | Netinst | USB | SD | SATA | mSATA |
|----|---------|-----|----|------|-------|
| Debian stable x64 | YES | YES | YES | YES | YES |
| Debian stable i386 | YES | YES | not tested | not tested | YES |
| Voyage 0.11 | YES | YES | NO(1) | not tested | not tested |

1) - when using netinst, sd card needs to be connected via USB card reader;
additionally Voyage works only in read-only mode. When rootfs is mounter as
read-write, write errors occur and kernel panics.

