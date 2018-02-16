pfSense installation tests
==========================

## Problem description

Apu boards with coreboot 4.6.x have problems with pfSense installation on hard
disks and platform sometimes hangs running this system.

```
ahcich1: Timeout on slot 4 port 0
ahcich1: is 00000008 cs 00000000 ss 00000000 rs ffffffff tfd 40 serr 00000000 cmd 00406417
(ada0:ahcich1:0:0:0): WRITE_FPDMA_QUEUED. ACB: 61 10 10 c0 d6 40 26 00 00 00 00 00
(ada0:ahcich1:0:0:0): CAM status: Command timeout
(ada0:ahcich1:0:0:0): Retrying command
ahcich1: Timeout on slot 5 port 0
ahcich1: is 00000002 cs 00000000 ss 00000000 rs 00000020 tfd 50 serr 00000000 cmd 00406517
(aprobe0:ahcich1:0:0:0): ATA_IDENTIFY. ACB: ec 00 00 00 00 40 00 00 00 00 00 00
(aprobe0:ahcich1:0:0:0): CAM status: Command timeout
(aprobe0:ahcich1:0:0:0): Retrying command
ahcich1: Timeout on slot 6 port 0
ahcich1: is 00000002 cs 00000000 ss 00000000 rs 00000040 tfd 50 serr 00000000 cmd 00406617
(aprobe0:ahcich1:0:0:0): ATA_IDENTIFY. ACB: ec 00 00 00 00 40 00 00 00 00 00 00
(aprobe0:ahcich1:0:0:0): CAM status: Command timeout
(aprobe0:ahcich1:0:0:0): Error 5, Retries exhausted
ahcich1: Timeout on slot 7 port 0
ahcich1: is 00000002 cs 00000000 ss 00000000 rs 00000080 tfd 50 serr 00000000 cmd 00406717
(aprobe0:ahcich1:0:0:0): ATA_IDENTIFY. ACB: ec 00 00 00 00 40 00 00 00 00 00 00
(aprobe0:ahcich1:0:0:0): CAM status: Command timeout
(aprobe0:ahcich1:0:0:0): Error 5, Retry was blocked
ada0 at ahcich1 bus 0 scbus1 target 0 lun 0
ada0: <ST1000LM014-SSHD-8GB LVD3> s/n W380YWQN detached
```

After command timeout, the disk is being detached and installation stops.


## Possible reasons

Community and tests tells that problem exist only in coreboot 4.6.x. Legacy
version seems to be unaffected. After dumping the SATA controller registers at
the end of ramstage for both coreboot 4.6.x and 4.0.x one can see slight
differences in the content of registers. The main differences worth attention
are:

1. Watch Dog Control And Status Register(PCI dev 11 fun 0 offset 0x44):

    - Watchdog disabled in 4.6.x
    - Watchdog counter not set properly (reset state) in 4.6.x

2.  PHY Core Control 2 Register (PCI dev 11 fun 0 offset 0x84):

    - PHY PLL Dynamic Shutdown enabled (reset state) in 4.6.x (disabled in legacy)

3. HBA Capabilities Register (SATA Memory Mapped AHCI Registers offset 0x0):

    - Command Completion Coalescing Supported bit set (reset state) in 4.6.x
      (disabled in legacy) - this bit is read-only so its state depends on AGESA

Even if these differences are eliminated, the problem still occurs. This may
lead to a conclusion, that AGESA code part that was ported from `3rdparty/blobs`
to `src/vendorcode` does not behave exactly as in legacy.

Checking the disk with `smartctl` command does not give any clue too:

```
SMART Error Log Version: 1
ATA Error Count: 1
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 1 occurred at disk power-on lifetime: 3920 hours (163 days + 8 hours)
  When the command that caused the error occurred, the device was in an unknown state.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 71 00 03 00 00 40  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  00 00 00 00 00 00 00 ff      01:56:32.276  NOP [Abort queued commands]
  00 00 00 00 00 00 00 ff      01:56:26.955  NOP [Abort queued commands]
  ea 00 00 00 00 00 a0 00      01:56:22.973  FLUSH CACHE EXT
  61 00 08 ff ff ff 4f 00      01:56:22.973  WRITE FPDMA QUEUED
  ea 00 00 00 00 00 a0 00      01:56:22.962  FLUSH CACHE EXT
```

Digging in the FreeBSD forums gave me a hint that migration from kernel 10.x to
11.x, which takes place between pfSense versions 2.3.x and 2.4.x, caused many
problems with hard disk. There were major changes to AHCI and many users
complained at the same issue mentioned in this paper. I have read that
customizing the installation may solve this issue.

## Solution and tests

I have found many possible solutions on FreeBSd forums:

- change power saving policy for AHCI: `hint.ahcich.x.pm_level="y"`
  (x - channel, y - level [0-5])
- disable ATA DMA `hint.ata.0.mode=PIO4`
- disable Message Signaled Interrupts (MSI) for ATA `hint.ahci.x.msi="0"`
  (x - SATA controller)

I have tested few BIOS versions like 4.0.11, 4.0.14, 4.6.1, 4.6.4. I have used
the SATA port available on port and Seagate HDD:

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


The 4.0.x versions did not need any modifications. After performing over 15
installations no error occured.

Problems only appeared in 4.6.x versions.

|BIOS version|clean|PM level 0|DMA disabled|MSI disabled|
|------------|-----|----------|------------|------------|
|   v4.6.1   | FAIL|   FAIL   |    FAIL    |    PASS    |
|   v4.6.4   | FAIL|   FAIL   |    FAIL    |    PASS    |

`PASS` - over 15 installations finished without errors

As the name of modification says, it is a hint for installer to not use such
features. Tests show that when installer is not using MSI the installation goes
without errors. In other cases installation fails after 0-5 good installations
in a row.

I have found answers on FreeBSD forums that signal races occur and this leads
to timeouts on disk operations. Disabling MSI seems to solve this problem.

The same solution can be utilized in the installed system. Appending
`hint.ahci.0.msi="0"` to `/boot/loader.conf.local` should prevent system hang.
