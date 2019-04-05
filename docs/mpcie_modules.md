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
