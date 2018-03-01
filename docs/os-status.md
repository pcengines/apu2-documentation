Tested operating systems
========================

## OS status

Some operating system have problems running with different storage medias.
These table shows currently tested systems on BIOS v4.6.x with corresponding
medias:

|     OS     | SD card | SATA disk | mSATA disk | USB stick |
|------------|---------|-----------|------------|-----------|
|   Voyage   |    X1   |     OK    |     OK     |    *2     |
|   Debian   |    OK   |     OK    |     OK     |    *2     |
|   pfSense  |    OK   |     *1    | not tested |    *2     |

*1 - issues with installation and system functionality (installation break,
     unwanted reboots), can be fixed by adding a hint `hint.ahci.0.msi="0"`,
     for more information see this [document](docs/pfSense-install-guide.md)

*2 - all apu boards have problems with USB 3.x stick detection in BIOS,
     system is working properly, but after reboot/warmboot/coldboot USB stick
     may not appear in BIOS boot menu (depends on the stick, well working sticks
     are mentioned in this [document](docs/debug/usb-tests.md))

X1 - Voyage Linux is bootable on SD card and works well in read-only mode,
     remounting as read-write and writing changes to SD sometimes results
     in kernel panic which often leads to non-operable system


Voyage Linux 0.11:

```
Linux voyage 4.1.6-voyage #1 SMP Thu Jun 2 17:53:20 HKT 2016 x86_64 GNU/Linux
```

Linux Debian:

```
Linux debian 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3+deb9u1 (2017-12-23) x86_64 GNU/Linux
```

pfSense:

```
FreeBSD pfSense.localdomain 11.1-RELEASE-p4 FreeBSD 11.1-RELEASE-p4 #5
r313908+79c92265a31(RELENG_2_4): Mon Nov 20 08:18:22 CST 2017
root@buildbot2.netgate.com:/builder/ce-242/tmp/obj/builder/ce-242/tmp/FreeBSD-src/sys/pfSense  amd64
```

## Tested mediasos-


SD card:
```
CID: 0353445343313647806cb1100a011a00
CSD: 400e00325b59000076b27f800a404000
DSR: 0x404
FW Rev: 0x0
HW Rev: 0x8
Manufacturer ID: 0x000003
Name: SC16G
OCR: 00200000
OEM ID: 0x5344
SCR: 0235844300000000
Serial: 0x6cb1100a
SSR:
0000000004000000040090000f050a0000000000000100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000
```

HDD:
```
Model Family:     Seagate Laptop SSHD
Device Model:     ST1000LM014-SSHD-8GB
Serial Number:    W380YWQN
LU WWN Device Id: 5 000c50 06e82fb73
Firmware Version: LVD3
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      2.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Feb  7 11:06:32 2018 GMT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```


mSATA SSD:
```
Device Model:     SATA SSD
Serial Number:    A1AE076419DF00167089
Firmware Version: S9FM02.8
User Capacity:    16,013,942,784 bytes [16.0 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      mSATA
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-3 (minor revision not indicated)
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Wed Feb 21 13:24:02 2018 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```

USB sticks parameters are presented in this document: [USB tests](docs/debug/usb-tests.md)