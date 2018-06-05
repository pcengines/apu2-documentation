PC Engines apu feature set
==========================

## Coreboot features

| Feature                       | Status    | Comment   | Test case |
|-------------------------------|-----------|-----------|-----------|
| CBFS option mPCIe2 clk        | YES       |  |  |
| CBFS option EHCI0             | YES       |  |  |
| CBFS option console           | YES       |  |  |
| CBFS option UARTc/d           | YES       |  |  |
| Serial number from NIC        | YES       |  |  |
| Serial number from SPI flash  | YES       |  |  |
| S1 button                     | YES(1)    |  |  |
| SATA AHCI                     | YES(2)    |  |  |
| Serial console enable/disable | YES(3)    |  |  |
| SIMSWAPs                      | YES(4)    |  |  |
| SMBIOS table short partnumber | YES       |  |  |

1) apu5 has no support for S1
2) only mainline releases
3) apu5 support only disable option, S1 button not supported yet
4) apu3 seems to have inverted functionality

# SeaBIOS features

| Feature                        | Status    | Comment   | Test case |
|--------------------------------|-----------|-----------|-----------|
| OHCI/UHCI disabled             | YES       |  |  |
| ATA UDMA                       | YES       |  |  |
| Boot menu timeout 6s           | YES       |  |  |
| F10 button to enter boot menu  | YES       |  |  |
| Custom boot menu string        | YES       |  |  |
| N for iPXE boot string         | YES       |  |  |
| Hiding iPXE rom                | YES       |  |  |
| USB boot enable/disable        | YES       |  |  |
| USB xHCI timing adjustments    | YES(1)    |  |  |
| Serial console enable/disable  | YES(2)    |  |  |
| Bootorder configuration file   | YES       |  |  |
| Sercon-port configuration file | YES       |  |  |

1) some sticks seem to not work still, additionally apu4 has problems with
two sticks simultaneously plugged
2) apu5 do not yet support serial console enable

# iPXE features

| Feature                        | Status    | Comment   | Test case |
|--------------------------------|-----------|-----------|-----------|
| Output not duplicated          | YES       |  |  |
| Custom iPXE menu               | YES       |  |  |

# Memtest86+ features

| Feature                        | Status    | Comment   | Test case |
|--------------------------------|-----------|-----------|-----------|
| Correct SMBus base             | YES(1)    |  |  |
| Screen refresh                 | YES       |  |  |

1) SMBus base is correct for apu2 series, Memtest86+ hangs on apu1

# Sortbootorder features

| Feature                        | Status    | Comment   | Test case |
|--------------------------------|-----------|-----------|-----------|
| Setting bootorder priority     | YES       |  |  |
| PXE boot enable/disable        | YES       |  |  |
| USB boot enable/disable        | YES       |  |  |
| Serial console enable/disable  | YES       |  |  |
| UARTc/d enable/disable         | YES       |  |  |
| Force mPCIe2 clk               | YES       |  |  |
| BIOS WP enable/disable         | YES       |  |  |
| Restore default options        | YES       |  |  |
| EHCI0 enable/disable           | YES       |  |  |
| Bootorder is aligned correctly | YES       |  |  |
| Security registers             | YES(1)    |  |  |

1) locking OTP registers seems to not work

# Operating systems and storages

| Operating system    | Status    | Comment   | Test case |
|---------------------|-----------|-----------|-----------|
| Debian amd64 4.14.y |  |  |  |
| Debian amd64 4.15.y |  |  |  |
| Debian amd64 4.16.y |  |  |  |
| CoreOS stable       |  |  |  |
| Xen 4.9             |  |  |  |

# Operating systems and storages

| Operating System    | Storage | Status | Comment | Test case |
|---------------------|---------|--------|---------|-----------|
| Debian stable amd64 | USB     |  |  |  |
| Debian stable amd64 | SD      |  |  |  |
| Debian stable amd64 | SATA    |  |  |  |
| Debian stable amd64 | mSATA   |  |  |  |
||||||
| Debian stable i386  | USB     |  |  |  |
| Debian stable i386  | SD      |  |  |  |
| Debian stable i386  | SATA    |  |  |  |
| Debian stable i386  | mSATA   |  |  |  |
||||||
| Voyage Linux 0.11   | USB     |  |  |  |
| Voyage Linux 0.11   | SD      |  | (1) |  |
| Voyage Linux 0.11   | SATA    |  |  |  |
| Voyage Linux 0.11   | mSATA   |  |  |  |
||||||
| pfSense 2.4.3       | USB     |  |  |  |
| pfSense 2.4.3       | SD      |  |  |  |
| pfSense 2.4.3       | SATA    |  |  |  |
| pfSense 2.4.3       | mSATA   |  |  |  |
||||||
| pfSense 2.3.5       | USB     |  |  |  |
| pfSense 2.3.5       | SD      |  |  |  |
| pfSense 2.3.5       | SATA    |  |  |  |
| pfSense 2.3.5       | mSATA   |  |  |  |
||||||
| Core 6.4            | USB     |  |  |  |
| Core 6.4            | SD      |  |  |  |
| Core 6.4            | SATA    |  |  |  |
| Core 6.4            | mSATA   |  |  |  |

1) when installing on sd, sd card needs to be connected via USB card reader;
additionally Voyage works only in read-only mode. When rootfs is mounted as
read-write, write errors occur and kernel panics.

