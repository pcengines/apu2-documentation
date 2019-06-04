List of supported mPCIe modules
===============================

This document contains a list of supported WiFi and LTE modules in mini PCI
Express card form factor. Document intends to present limitations of the
modules and quirks necessary for their flawless operation.

> The list is currently limited only to tested and verified modules

## LTE modules

### Quectel EP06

![Quectel EP06](https://www.quectel.com/UploadImage/Product/20171016143013431.png)

This LTE module has certain problems with detection in the operating systems.
The module uses a USB interface to communicate with the processor and OS. Due
to the availability of USB 2.0 and USB 3.0 interfaces in the module, it often
gets enumerated incorrectly. The presence of USB 3.0 lanes causes the module to
use the USB 3.0 protocol instead of the USB 2.0 protocol. The mPCIe slots on
apu boards have only USB 2.0 signals routed to the connectors. In place of the
USB 3.0 signals, apu boards have either PCIe signals or SATA signals for WiFi
and mSATA modules respectively. The design of the modules is intended to
support majority of the modules, but it will not always be compatible with all
possible modules, please take it into consideration.

**Symptoms of the wrong detection:**

- only 1 ttyUSB node created by OS
- no ttyUSB nodes created by OS
- errors in USB enumeration for the module in dmesg

**Solutions:**

1. Contact PC Engines for a module firmware update with USB 3.0 protocol
   disabled if You have problems with module detection.
2. Cover USB 3.0 signals on the module with tape to block signal connection as
   shown in the picture:

![Quectel EP06 pinout](images/quectel_pinout.png)

Black pins mean that they have to be covered with tape. The 6 black pins on
the top side are USB3.0 signals. Two pins on the bottom side are I2C/SMBus pins
which also should be covered with tape. The module design requires pull-ups on
the mainboard side, but they are not present on apu.

**Compatible slots:**

| Platform |  mPCIe1  |  mPCIe2  |     mSATA      |
|:--------:|:--------:|:--------:|:--------------:|
|   apu2   | &#10004; | &#10004; | &#10006;       |
|   apu3   | &#10006; | &#10004; | &#10004; &sup1;|
|   apu4   | &#10006; | &#10004; | &#10004; &sup1;|

(1) Do not forget to enable EHCI0 controller in sortbootorder

> For each port's capabilities please refer to [mPCIe port capabilities](APU_mPCIe_capabilities.md)

### HUAWEI ME909u

![HUAWEI ME909u](https://www.4gltemall.com/media/catalog/product/cache/1/image/650x650/9df78eab33525d08d6e5fb8d27136e95/h/u/huawei_me909u-521.jpg)

This module works fairly well with all apu boards.

**Compatible slots:**

| Platform |  mPCIe1  |  mPCIe2  |     mSATA      |
|:--------:|:--------:|:--------:|:--------------:|
|   apu2   | &#10004; | &#10004; | &#10006;       |
|   apu3   | &#10006; | &#10004; | &#10004; &sup1;|
|   apu4   | &#10006; | &#10004; | &#10004; &sup1;|

## WiFi modules

### WLE200NX

![WLE200NX](http://shop.compex.com.sg/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/w/l/wle200nx_new_1500.jpg)

This module works fairly well with all apu boards.

**Compatible slots:**

| Platform |  mPCIe1  |  mPCIe2  |  mSATA   |
|:--------:|:--------:|:--------:|:--------:|
|   apu2   | &#10004; | &#10004; | &#10006; |
|   apu3   | &#10004; | &#10006; | &#10006; |
|   apu4   | &#10004; | &#10006; | &#10006; |

**Quirks:**

- Sometimes the module may have problems with OS communication on mainline
  releases. In such case providing `amd_iommu=off` to kernel command line may
  help.

### WLE600VX

![WLE600VX](http://www.compexshop.com/images/WLE900VX_r.png)

This module works fairly well with all apu boards. Tested by PC Engines and apu
users.

**Compatible slots:**

| Platform |  mPCIe1  |  mPCIe2  |  mSATA   |
|:--------:|:--------:|:--------:|:--------:|
|   apu2   | &#10004; | &#10004; | &#10006; |
|   apu3   | &#10004; | &#10006; | &#10006; |
|   apu4   | &#10004; | &#10006; | &#10006; |

**Quirks:**

- Sometimes the module may have problems with OS communication on mainline
  releases. In such case providing `amd_iommu=off` to kernel command line may
  help.

### WLE900VX

![WLE900VX](http://www.compexshop.com/images/WLE900VX-itemp_r.png)

This module works fairly well with all apu boards.

**Compatible slots:**

| Platform |  mPCIe1  |  mPCIe2  |  mSATA   |
|:--------:|:--------:|:--------:|:--------:|
|   apu2   | &#10004; | &#10004; | &#10006; |
|   apu3   | &#10004; | &#10006; | &#10006; |
|   apu4   | &#10004; | &#10006; | &#10006; |

**Quirks:**

- Sometimes the module may have problems with OS communication on mainline
  releases. In such case providing `amd_iommu=off` to kernel command line may
  help.

### WLE1216V5-20

![WLE1216V5-20](https://compex.com.sg/wp-content/uploads/2018/09/wle1216v5-20.jpg)

Correct detection of this module is a little tricky and hardware related. Due
to different PCI Express reset circuit on apu boards, apu2 has problems with
this particular module detection. Most likely due to different reset timing
caused by different `PE_RST` circuitry on apu2, the module does not come out
of reset in time during PCI enumeration and thus is not detected in BIOS and
operating system.

**Quirks:**

- On apu2 in mPCIe2 slot module works only after a soft reboot with legacy
  firmware, however during the tests we have encountered kernel panics. On the
  other hand users did not experience kernel panics and are able to use the
  module after reboot. The apu2 board revision plays a huge role in the
  mentioned problems.
- on apu3 and apu4 the module works with any firmware and does not require
  reboot

| Platform |  mPCIe1  |     mPCIe2      |  mSATA   |
|:--------:|:--------:|:---------------:|:--------:|
|   apu2   | &#10006; | &#10004; &sup1; | &#10006; |
|   apu3   | &#10004; | &#10006;        | &#10006; |
|   apu4   | &#10004; | &#10006;        | &#10006; |

(1) Refer to quirks, it is known to not work stably on all apu2 board revisions

## Ethernet controllers

### Dual Ethernet Controller Realtek RTL8111

![RTL8111](images/realtek_controller.jpg)

**Compatible slots**

| Platform |  mPCIe1  |     mPCIe2      |  mSATA   |
|:--------:|:--------:|:---------------:|:--------:|
|   apu2   | &#10004; | &#10004; &sup1; | &#10006; |
|   apu3   | &#10004; | &#10006;        | &#10006; |
|   apu4   | &#10004; | &#10006;        | &#10006; |

(1) If RTL8111 is attached to mPCIe2 slot then option *force mPCIe2 slot Clk* in
Payload menu must be enabled

This model works well with apu1 boards. However, on apu2, apu3 and apu4
platforms following steps should be done to correctly enable it:

1. On apu2 board (apu1, apu3 and apu4 boards aren't affected) make sure to
enable option *force mPCIe2 slot Clk* in Payload menu if you attached module to
mPCIe2 slot. This menu is available during boot process by pressing `F10`
button. In OS now, you should be able to see your Ethernet controller under PCI
devices.

2. Manually download and install missing Realtek firmware. Even if Ethernet
controller is recognized by OS it won't work correctly without it. Installation
can be done, for example in Debian OS, by performing those steps:

    - Edit `/etc/apt/sources.list` file. It should contain additional two
    lines:
    ```
    deb http://ftp.pl.debian.org/debian stretch main non-free
    deb-src  http://ftp.pl.debian.org/debian stretch main non-free   
    ```
    - Update apt-get:
    ```
    sudo apt-get update
    ```
    - Install Realtek firmware
    ```
    sudo apt-get install firmware-realtek
    ```

## SATA controllers


### ASMedia ASM1061

ASM1061 was tested with Delock 95233 mPCIe 2xSATA module.

![ASM1061](images/delock_95233.png)

**Compatible slots**

Due to apu boards construction, it is possible to test that module only under
apu2 mPCIe2 slot. Slot mPCIe1 at any platform is unreachable. SATA connectors in
Delock 95233 are on the side, which makes it impossible to attach hard drive
(capacitors next to mPCIe1 slot block it).

**Tests configurations**

Testing ASM1061 was performed for 2 types of Delock 95233 modules:
- module with soldered R58&sup1; resistor
- modified module without R58&sup1; resistor

(1) R58 resistor is placed next to CON1 connector

Test results are the same for both types of modules and as follows:

1. Delock module is attached to mPCIe2 slot and SATA disk is connected before
platform boot process.

  In that case boot process went into 'infinite boot loop'. It went to payload
  menu, hanged and after few seconds performed reboot automatically. During
  booting, user can't do any action. There are no response from apu platform to
  any button pressing. Only option to went through boot process without troubles
  is to disconnect SATA disk and reboot platform again.

2. Delock module is attached to mPCIe2 slot, but no SATA disk is connected
before and during platform boot process.

  Boot process goes smoothly to seaBIOS menu and OS booting was performed
  correctly also. Under Debian OS, ASM controller is detected (check it with
  e.g. `dmesg | grep "ahci"`.

  ```
  root@debian:~# dmesg | grep "ahci"
[    9.370761] ahci 0000:00:11.0: version 3.0
[    9.371737] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    9.380220] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp fbs pio slum part ccc
[    9.389294] ahci 0000:00:11.0: both AHCI_HFLAG_MULTI_MSI flag set and custom irq handler implemented
[    9.401327] scsi host0: ahci
[    9.407101] scsi host1: ahci
[    9.432821] ahci 0000:01:00.0: SSS flag set, parallel bus scan disabled
[    9.564657] ahci 0000:01:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    9.572796] ahci 0000:01:00.0: flags: 64bit ncq sntf stag led clo pmp pio slum part ccc sxs
[    9.583302] scsi host2: ahci
[    9.586835] scsi host3: ahci

  ```
  Ahci 0000:01:00.0 is Dealock 95233 SATA controller.

  After plugged-in SATA disk (no matter to what SATA port), configuration
  problems appeared. Although, OS was trying to communicate with SATA, some
  warnings and errors occurred. Example log is shown below.

  ```
  [   68.190693] ata3: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
  [   68.198142] ata3: irq_stat 0x00000040, connection status changed
  [   68.204199] ata3: SError: { CommWake DevExch }
  [   68.208743] ata3: hard resetting link
  [   73.826743] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
  [   73.839192] ata3.00: ATA-8: ST500LM012 HN-M500MBB, 2AR10002, max UDMA/133
  [   73.846011] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
  [   73.859579] ata3.00: configured for UDMA/133
  [   73.863903] ata3: EH complete
  [   73.867515] scsi 2:0:0:0: Direct-Access     ATA      ST500LM012 HN-M5 0002 PQ: 0 ANSI: 5
  [   73.876569] sd 2:0:0:0: Attached scsi generic sg1 type 0
  [   73.876592] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/466 GiB)
  [   73.876597] sd 2:0:0:0: [sdb] 4096-byte physical blocks
  [   73.876665] sd 2:0:0:0: [sdb] Write Protect is off
  [   73.876827] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  [   73.941291]  sdb: sdb1 sdb2 < sdb5 >
  [   73.946498] sd 2:0:0:0: [sdb] Attached SCSI disk
  ```

Pay attention that some data is sent correctly between controller and OS (e.g.
HDD disk information or configuration). However, platform hanged in that stage
and didn't respond to any command. Therefor, faultless connection can't be
established and HDD disk plugged via Delock module can't be treated as working.

**Possible reasons**

It looks like problem can be considered rather as hardware. Also it is Delock
95233 module/ASM1061 controller problem. Tested SATA disk works fine when
attached to SATA connector on apu2 board. After searching solutions, 2 main
appears as most useful:

- Power supply is not sufficient and drops out to too low level. However, tested
disk was powered with around 5V. Problems with power supply drop out occurred
in some  SATA disk, but mostly are related to 12V disks

- Low quality cables and connectors on Delock module

Both solutions haven't been tested yet. But it looks like they should be
considered and carried out.

## Other hardware fixes

A good source of hardware fixes information of Your board is the
[PC Engines site](https://pcengines.ch/).

If You think Your problem may be related to issues listed here, contact PC
Engines for details.

If You have not found a solution either after reading this document or
contacting PC Engines, feel free to open [GitHub issue.](https://github.com/pcengines/coreboot/issues)

### apu2

Set of changes for apu2:

**Version apu2d:**

- Reduce leakage current between V3 and V3A power rails (can cause problems
  with SD cards).
- Add options for better compatibility with LTE modem modules.

**Version apu2c:**

- Integrate blue wire patches (EMI, power-up circuit) into PCB fab.

### apu3

Set of changes for apu3:

**Version apu3c:**

- Improve compatibility with LTE modem modules: Disconnect SMB_DAT / SMB_CLK
  signals (1.8V level on Quectel).
- Improve compatibility with LTE modem modules: No stuff diodes D4 / D17,
  option resistor bypass (extremely low VIL on Huawei modems, sensitive to
  incoming EMI).
- Optional SIM presence indicator / SIM card detect.
- Disable non-functional NCT5104D watchdog timer.
- Increase 3.3V current limit to allow for two simultaneous LTE modems.
- Some DFM changes.

**Version apu3b:**

- Fixed USB header J13 pinout.

**Version apu3a:**

- The pinout on USB header J13 is wrong, do not use.

### apu4

Set of changes for apu4:

**Version apu4c:**

- Minimize leakage from V3A to V3 rail (SD card compatibility)
- Fix USB header J12 pinout.
- Change SIM switch to FXLA2203, FXLA2204 went EOL.
- New 2GB version apu4c2, single SIM socket.
- Optional 10 pin LPC header to allow for future TPM option.
