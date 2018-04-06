Release notes
=============

Release notes describing changes, fixes and known issues in PC Engines apux
releases:

- [Mainline releases](#mainline-releases)
	- [v4.6.7](#v467)
	- [v4.6.6](#v466)
	- [v4.6.5](#v465)
	- [v4.6.4](#v464)
	- [v4.6.3](#v463)
	- [v4.6.2](#v462)
	- [v4.6.1](#v461)

- [Legacy releases](#legacy-releases)
	- [v4.0.15](#v4015)
	- [v4.0.14](#v4014)
	- [v4.0.13](#v4013)
	- [v4.0.12](#v4012)
	- [v4.0.11](#v4011)
	- [v4.0.10](#v4010)
	- [v4.0.9](#v409)

## Mainline releases

### v4.6.7

Release date: 2018-03-01

- Fixed/added:
    - SD card low performance
    - SMBIOS wrong entries
    - xHCi is enabled (timeouts has been adjusted in SeaBIOS, as a result
      USB 3.x sticks detection rate increased)
- Knowns issues:
    - pfSense installation may fail on hard disks - [workaround](pfSense-install-guide.md)
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.7](https://cloud.3mdeb.com/index.php/s/VLbTs6yHKkv1rmX/download)
- [apu3 v4.6.7](https://cloud.3mdeb.com/index.php/s/T5ZJePvgmEtHxFY/download)
- [apu4 v4.6.7](https://cloud.3mdeb.com/index.php/s/CTzs68GXxBcxhny/download)
- [apu5 v4.6.7](https://cloud.3mdeb.com/index.php/s/8YjFMi1CcnjliHi/download)

### v4.6.6

Release date: 2018-01-31

- Fixed/added:
    - SeaBIOS 1.11.0.3 - enabled UDMA for faster boot, fixed serial
      console disable bug
    - screen is refreshed properly in Memtest86+
- Known issues:
    - pfSense installation may fail on hard disks
    - pfSense can not be installed from USB due to xHCi disabled
    - USB 3.x sticks are handled like USB 2.0 sticks, but are detected
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.6](https://cloud.3mdeb.com/index.php/s/5jGaJvPwNLQCMl9/download)
- [apu3 v4.6.6](https://cloud.3mdeb.com/index.php/s/jwIgOZRNAkuIxde/download)
- [apu4 v4.6.6](https://cloud.3mdeb.com/index.php/s/HADHYzg7DiR2f2i/download)
- [apu5 v4.6.6](https://cloud.3mdeb.com/index.php/s/kTZtt1TtRzhEvCX/download)

### v4.6.5

Release date: 2017-12-29

- Fixed/added:
    - SeaBIOS 1.11.0.2 - fixes bug with serial console output shift
    - disabled xHCI, force EHCI controller on front ports
- Known issues:
    - pfSense installation may fail on hard disks
    - pfSense can not be installed from USB due to xHCi disabled
    - USB 3.x sticks are handled like USB 2.0 sticks, but are detected
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - refreshing screen dos not work properly in Memtest86+
    - serial console disable option does not affect SeaBIOS
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.5](https://cloud.3mdeb.com/index.php/s/CQRW1HIPRZRiwPW/download)
- [apu3 v4.6.5](https://cloud.3mdeb.com/index.php/s/nvoC3qjchgI3mFG/download)
- [apu4 v4.6.5](https://cloud.3mdeb.com/index.php/s/9pRt5JrWTHxB6Fo/download)
- [apu5 v4.6.5](https://cloud.3mdeb.com/index.php/s/j5oznHOARUmMZTF/download)

### v4.6.4

Release date: 2017-11-30

- Fixed/added:
    - apu4 support
    - updated SeaBIOS 1.11.0.1 (removed sgabios)
    - Memtest86+ is built from coreboot Memtest86+ repository
- Known issues:
    - pfSense installation may fail on hard disks - [workaround](pfSense-install-guide.md)
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - restoring default configuration in sortbootorder works only for
      bootorder
    - refreshing screen dos not work properly in Memtest86+
    - serial console disable option does not affect SeaBIOS
    - SeaBIOS serial console output is sometimes wrongly shifted
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries
- [apu2 v4.6.4](https://cloud.3mdeb.com/index.php/s/JNr4h8BWmDjte3Q/download)
- [apu3 v4.6.4](https://cloud.3mdeb.com/index.php/s/8FDbSyCjhfVOd0d/download)
- [apu4 v4.6.4](https://cloud.3mdeb.com/index.php/s/4IZdYSKO8vSEd7z/download)
- [apu5 v4.6.4](https://cloud.3mdeb.com/index.php/s/VWrCm3PGUgBH0Fz/download)

### v4.6.3

Release date: 2017-10-30

- Fixed/added:
    - UARTc/c and mPCIe2 CLK enable/disable runtime configuration works
      now
- Known issues:
    - pfSense installation may fail on hard disks - [workaround](pfSense-install-guide.md)
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - restoring default configuration in sortbootorder works only for
      bootorder
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.3](https://cloud.3mdeb.com/index.php/s/40yS2BDPtQoBvSF/download)
- [apu3 v4.6.3](https://cloud.3mdeb.com/index.php/s/msLUBzcY9fwOps1/download)
- [apu5 v4.6.3](https://cloud.3mdeb.com/index.php/s/VTu9A9IceR0DILG/download)

### v4.6.2

Release date: 2017-09-29

- Fixed/added:
    - date format in sign-of-life string
    - Memtest86+ does nto hang now
- Known issues:
    - pfSense installation may fail on hard disks - [workaround](pfSense-install-guide.md)
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - UARTc/c and mPCIe2 CLK enable/disable runtime configuration do
      not work
    - restoring default configuration in sortbootorder works only for
      bootorder
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.2](https://cloud.3mdeb.com/index.php/s/MrZQu3PhkEn8iIp/download)
- [apu3 v4.6.2](https://cloud.3mdeb.com/index.php/s/kI9vkRIt6v4ubAY/download)
- [apu5 v4.6.2](https://cloud.3mdeb.com/index.php/s/YmAX1ddpT2hG4IJ/download)

### v4.6.1

Release date: 2017-08-30

- Fixed/added:
    - apu5 support
- Known issues:
    - pfSense installation may fail on hard disks - [workaround](pfSense-install-guide.md)
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - Memtest86+ hangs
    - UARTc/c and mPCIe2 CLK enable/disable runtime configuration do
      not work
    - restoring default configuration in sortbootorder works only for
      bootorder
    - SD card performance is lower than in legacy releases
    - some PCIe cards are not detected on certain OSes

Binaries:
- [apu2 v4.6.1](https://cloud.3mdeb.com/index.php/s/PECvT1IsD3Gm06h/download)
- [apu3 v4.6.1](https://cloud.3mdeb.com/index.php/s/vcZUg9ZvjvDbTV8/download)
- [apu5 v4.6.1](https://cloud.3mdeb.com/index.php/s/naKuOSYKxVisWvX/download)



## Legacy releases

### v4.0.15

Release date: 2018-03-01

- Fixed/added:
    - fixed Kconfig defautl options for SeaBISO repo, console loglevel
    - SMBIOS wrong entries
    - restoring default features in srotbootorder available now
    - iPXE is built from official iPXE repository, no need to build it
      externally
    - updated SeaBIOS to 1.11.0.3 (xHCI timeouts adjusted - USB 3.x
      sticks detection rate increased)
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu

Binaries:
- [apu2 v4.0.15](https://cloud.3mdeb.com/index.php/s/13od9cvY0LEmREv/download)
- [apu3 v4.0.15](https://cloud.3mdeb.com/index.php/s/J3Z5nAbXFP6y2Wz/download)
- [apu5 v4.0.15](https://cloud.3mdeb.com/index.php/s/ircYOIP1FsLwtsv/download)

### v4.0.14

Release date: 2017-12-22

- Fixed/added:
    - updated SeaBIOS to 1.11.0.2 (removed sgabios)
    - iPXE is built from official iPXE repository
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - restoring default configuration in sortbootorder works only for
      bootorder

Binaries:
- [apu2 v4.0.14](https://cloud.3mdeb.com/index.php/s/JoVlRzyyEFvlVmt/download)
- [apu3 v4.0.14](https://cloud.3mdeb.com/index.php/s/ZmL59E2KuyNIWwv/download)
- [apu5 v4.0.14](https://cloud.3mdeb.com/index.php/s/b06diBcMzdL2cbW/download)

### v4.0.13

Release date: 2017-09-29

- Fixed/added:
    - fixed date format in sign-of-life string
    - removed duplicated sign-of-life
    - sign-of-life do appears right after power on now
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes

Binaries:
- [apu2 v4.0.13](https://cloud.3mdeb.com/index.php/s/k3a298ibFUWCeyv/download)
- [apu3 v4.0.13](https://cloud.3mdeb.com/index.php/s/T17wH9nkHcZC1RJ/download)
- [apu5 v4.0.13](https://cloud.3mdeb.com/index.php/s/vBDGSiXmiuzSs1M/download)

### v4.0.12

Release date: 2017-08-30

- Fixed/added:
    - apu5 support
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - wrong names in SMBIOS causes some modules not being loaded on
      certain OSes
    - restoring default configuration in sortbootorder works only for
      bootorder

Binaries:
- [apu2 v4.0.12](https://cloud.3mdeb.com/index.php/s/Arw7rNlAwb4efAx/download)
- [apu3 v4.0.12](https://cloud.3mdeb.com/index.php/s/9JyLVWinsJzaK70/download)
- [apu5 v4.0.12](https://cloud.3mdeb.com/index.php/s/ZQDnNA0gFgbCVEt/download)

### v4.0.11

Release date: 2017-07-21

- Fixed/added:
    - force mPCIe2 CLK option in sortbootorder
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - restoring default configuration in sortbootorder works only for
      bootorder

Binaries:
- [apu2 v4.0.11](https://cloud.3mdeb.com/index.php/s/o5T8B7pZPQ8kEbp/download)
- [apu3 v4.0.11](https://cloud.3mdeb.com/index.php/s/7eIzXvaj8XV1gJB/download)

### v4.0.10

Release date: 2017-06-30

- Fixed/added:
    - sortbootorder is now available in Kconfig
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - restoring default configuration in sortbootorder works only for
      bootorder

Binaries:
- [apu2 v4.0.10](https://cloud.3mdeb.com/index.php/s/H6kT2tTIgijOJUT/download)
- [apu3 v4.0.10](https://cloud.3mdeb.com/index.php/s/nloJkadxf4VCbDc/download)

### v4.0.9

Release date: 2017-05-30

- Fixed/added:
    - minor fixes to sortbootorder used letters
- Known issues:
    - USB 3.x sticks happen to not appear in boot menu
    - restoring default configuration in sortbootorder works only for
      bootorder

Binaries:
- [apu2 v4.0.9](https://cloud.3mdeb.com/index.php/s/dlts5hf4Kr1IAk1/download)

