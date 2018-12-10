AMD I/O Virtualization Technology (IOMMU)
=========================================

This document is related to changes submitted to [mainline coreboot](https://review.coreboot.org/#/c/coreboot/+/26116/).

# Status

# 03/08/2018

* tested on [Linux 4.14.59](../configs/config-4.14.59)
* `xl pci-*` commands no longer hang
* `CPUX: No irq handler for vector e7` - platform sporadically hangs on this
log - [no irq handler](#no-irq-handler)
* patches cleanup according to review - compatibility was verified based on
  `dmesg` and `xl dmesg` comparison to previous patch version

Current [xl dmesg](logs/iommu_enabled_xl_dmesg_03082018.log) and [dmesg](logs/iommu_enabled_dmesg_03082018.log).


# 24/07/2018

* patches under redesign in upstream
* planned firmware release to include patches v4.8.0.3
* tested on Xen 4.8.3 and Debian stretch with Linux 4.14.50
* `xl dmesg` dump with apic and iommu verbose [here](logs/iommu_enabled_xl_dmesg.log)
* `CPUX: No irq handler for vector e7` log is still visible, but doesn't affect
boot process. We look for solution for that log [here](https://github.com/pcengines/coreboot/pull/186)
* platform survived 100x reboots to Xen without issue
* IOMMU groups are probably not assigned correctly to devices e.g. all NICs are in
  one group - [tl;dr: IOMMU groups](#iommu-groups) - this makes sense only for KVM
* after booting Debian (Linux 4.14.50) as dom0 I'm getting:
```
[    0.827436] AMD IOMMUv2 functionality not available on this system
```
* `xl pci-assignable-list` hangs? - machine is responsive e.g Ctrl-C works
* Assigning device also hangs? - machine is responsive e.g Ctrl-C works

```
root@apu2:~# xl pci-assignable-add 00:10.0
[  447.867457] xhci_hcd 0000:00:10.0: remove, state 1
[  447.867520] usb usb3: USB disconnect, device number 1
[  447.867538] usb 3-1: USB disconnect, device number 2
[  447.868530] usb 3-2: USB disconnect, device number 3
[  447.870692] xhci_hcd 0000:00:10.0: USB bus 3 deregistered
[  447.870752] xhci_hcd 0000:00:10.0: remove, state 4
[  447.870805] usb usb2: USB disconnect, device number 1
[  447.989825] xhci_hcd 0000:00:10.0: USB bus 2 deregistered
```

## Questions

* are we sure that IVRS contain correct entries for bridges?

# 06/05/2018

* patches submitted upstream
* patches included in v4.6.9 of PC Engines firmware release
* tested on Xen 4.8 with Linux 4.14.33:
```
(XEN) AMD-Vi: Disabled HAP memory map sharing with IOMMU
(XEN) AMD-Vi: IOMMU Extended Features:
(XEN)  - Peripheral Page Service Request
(XEN)  - Guest Translation
(XEN)  - Invalidate All Command
(XEN)  - Guest APIC supported
(XEN)  - Performance Counters
(XEN) AMD-Vi: IOMMU 0 Enabled.
```

**NOTE**: feature currently is not stable and hangs on Xen kernel 29/100 boots.:

```
(XEN) CPU1: No irq handler for vector e7 (IRQ -2147483648)
(XEN) CPU2: No irq handler for vector e7 (IRQ -2147483648)
<hang>
```

# How to check features with Xen
Please [read this blog post](TBD)

# How to test IOMMU features

## PCE pass-through

Boot Xen to Dom0:

```
modprobe xen-pciback
root@apu2:~# xl pci-assignable-add 02:00.0
[  136.778839] igb 0000:02:00.0: removed PHC on enp2s0
[  136.887658] pciback 0000:02:00.0: seizing device
[  136.888115] Already setup the GSI :32
root@apu2:~# xl pci-assignable-list
0000:02:00.0
```

Xen configured eth1 as PCI pass-through device. Now this device should be
assigned to guest and tested.

### pfSense HVM

Debugging
---------

Unfortunately previous work was not stable and according to comments from
Kyosti correct implementation should rely not on AGESA returned values, but on
custom IVRS generated in coreboot - this is approach that Timothy took
developing initial support.

Dump of IVRS from AGESA and custom made in above mentioned implementation:

```
Dump AGESA IVRS:
ivrs_agesa->header.signature: IVRSx
ivrs_agesa->header.length: 0x78
ivrs_agesa->header.revision: 0x2
ivrs_agesa->header.checksum: 0x9a
ivrs_agesa->header.oem_id: AMD   AGESA
ivrs_agesa->header.oem_table_id: AGESA
ivrs_agesa->header.oem_revision: 0x1
ivrs_agesa->header.asl_compiler_id: AMD
ivrs_agesa->header.asl_compiler_revision: 0x0
ivrs_agesa->iv_info: 0x203040
ivrs_agesa->ivhd.type: 0x10
/* In flags only HtTuneEn is disabled other enabled */
ivrs_agesa->ivhd.flags: 0xfe
ivrs_agesa->ivhd.length: 0x48
ivrs_agesa->ivhd.device_id: 0x2
ivrs_agesa->ivhd.capability_offset: 0x40
ivrs_agesa->ivhd.iommu_base_low: 0xf7f00000
ivrs_agesa->ivhd.iommu_base_high: 0x0
ivrs_agesa->ivhd.pci_segment_group: 0x0
ivrs_agesa->ivhd.iommu_info: 0x1300
/* According to datasheet, if IVinfo[EFRSup] = 0, then IOMMU Feature Info is
 * reserved. So despite AGESA set IOMMU Feature Info it should be ignored.
 * GTSup - Guest Translation supported: enabled
 * IASup - INALIDATE_IOMMU_ALL supported: enabled
 * PASmax - maxiumum PASID vaule supported: 0b01000 -> 8
 * PNCounters - number of performance counters: 0b010 -> 2
 * PNBanks - number of performance counter banks: 0b0000010 -> 2
 */
ivrs_agesa->ivhd.iommu_feature_info: 0x48824

Dump custom IVRS:
ivrs->header.signature: IVRS
ivrs->header.length: 0x100
ivrs->header.revision: 0x1
ivrs->header.checksum: 0xbb
ivrs->header.oem_id: CORE  COREBOOT
ivrs->header.oem_table_id: COREBOOT
ivrs->header.oem_revision: 0x0
ivrs->header.asl_compiler_id: CORE
ivrs->header.asl_compiler_revision: 0x0
ivrs->iv_info: 0x203040
ivrs->ivhd.type: 0x10
/* In flags HtTuneEn, Coherent, PreFSup and PPRSup are disabled other enabled */
ivrs->ivhd.flags: 0x1e
ivrs->ivhd.length: 0xd0
ivrs->ivhd.device_id: 0x2
ivrs->ivhd.capability_offset: 0x40
/ * why we have so different base address? */
ivrs->ivhd.iommu_base_low: 0xfeb00000
ivrs->ivhd.iommu_base_high: 0x0
ivrs->ivhd.pci_segment_group: 0x0
ivrs->ivhd.iommu_info: 0x1300
/* Everything disabled */
ivrs->ivhd.iommu_feature_info: 0x0
```

# Booting without IOMMU patches

`/proc/iomem` doesn't show any region assigned to `amd_iommu` as it is with
patches applied. This means we don't have other information about IOMMU base
address instead of this returned by AGESA. We can assign manual address as it
was done in initial patch, but this makes Linux kernel not bootable.

# Try minimal changes - only IOMMU bese address

Minimal change which, just use IOMMU base low and high returned by AGESA also
not work correctly. Kernel crashing with following log:

```
[    1.064229] AMD-Vi: IOMMU performance counters supported
[    1.069579] BUG: unable to handle kernel paging request at ffffaffc4065c000
[    1.073554] IP: iommu_go_to_state+0xf8a/0x1260
[    1.073554] PGD 12a11f067 P4D 12a11f067 PUD 12a120067 PMD 129b69067 PTE 0
[    1.073554] Oops: 0000 [#1] SMP NOPTI
[    1.073554] Modules linked in:
[    1.073554] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.14.50 #13
[    1.073554] Hardware name: PC Engines apu2/apu2, BIOS 4.8-1174-gf12b3046f0-d2
[    1.073554] task: ffff8d5d69b9f040 task.stack: ffffaffc40648000
[    1.073554] RIP: 0010:iommu_go_to_state+0xf8a/0x1260
[    1.073554] RSP: 0018:ffffaffc4064be28 EFLAGS: 00010282
[    1.073554] RAX: ffffaffc40658000 RBX: ffff8d5d69bae000 RCX: ffffffff99e57b88
[    1.073554] RDX: 0000000000000000 RSI: 0000000000000092 RDI: 0000000000000246
[    1.073554] RBP: 0000000000000040 R08: 0000000000000001 R09: 0000000000000170
[    1.073554] R10: 0000000000000000 R11: ffffffff9a435e2d R12: 0000000000000000
[    1.073554] R13: ffffffff9a29a830 R14: 0000000000000000 R15: 0000000000000000
[    1.073554] FS:  0000000000000000(0000) GS:ffff8d5d6ec80000(0000) knlGS:00000
[    1.073554] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.073554] CR2: ffffaffc4065c000 CR3: 000000010fa0a000 CR4: 00000000000406e0
[    1.073554] Call Trace:
[    1.073554]  ? set_debug_rodata+0x11/0x11
[    1.073554]  amd_iommu_init+0x11/0x89
[    1.073554]  pci_iommu_init+0x16/0x3f
[    1.073554]  ? e820__memblock_setup+0x60/0x60
[    1.073554]  do_one_initcall+0x51/0x190
[    1.073554]  ? set_debug_rodata+0x11/0x11
[    1.073554]  kernel_init_freeable+0x16b/0x1ec
[    1.073554]  ? rest_init+0xb0/0xb0
[    1.073554]  kernel_init+0xa/0xf7
[    1.073554]  ret_from_fork+0x22/0x40
[    1.073554] Code: d2 31 f6 48 89 df e8 d8 15 02 ff 85 c0 75 d1 48 8b 44 24 2
[    1.073554] RIP: iommu_go_to_state+0xf8a/0x1260 RSP: ffffaffc4064be28
[    1.073554] CR2: ffffaffc4065c000
[    1.073554] ---[ end trace 44588f98aa7c7c0b ]---
[    1.255973] Kernel panic - not syncing: Attempted to kill init! exitcode=0x09
[    1.255973]
[    1.259934] ---[ end Kernel panic - not syncing: Attempted to kill init! exi9
```

If this is related to performance countres good idea could be to copy its
configuration from AGESA.

# Try whole IVHD from AGESA and device entries from initial commit

This version leads to hang after couple reboots. It was not tested but we
suspect similar effect to mentioned above in [Status for 06/05/2018](#status).

# Performance counters from AGESA

This seems to work, platform survived 100x reboots to Xen without even one
issue.

# IOMMU groups

It happened that in firmware based on [v8](https://review.coreboot.org/#/c/coreboot/+/27602/8) IOMMU groups in Linux
4.14.50 seem to be assigned incorrectly. According to [Arch Wiki](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Ensuring_that_the_groups_are_valid)
groups is smallest unit in which devices can be assigned to guests.

I'm not sure if this expected, but in Xen 4.8 with the same kernel driver is
not loaded and there are no IOMMU groups present. `dmesg` complain:

```
[    0.827423] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    0.827436] AMD IOMMUv2 functionality not available on this system
```

Difference between kernels is parameter provided on boot `amd_iommu_dump=1`
which is present in plain 4.14.50 without Xen.


 Ideally we
would like to have each device in other group. What we see right now is:

```
IOMMU Group 0 00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1566]
IOMMU Group 1 00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:156b]
IOMMU Group 1 00:02.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1 [1022:1439]
IOMMU Group 1 00:02.3 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1 [1022:1439]
IOMMU Group 1 00:02.4 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1 [1022:1439]
IOMMU Group 1 01:00.0 Ethernet controller [0200]: Intel Corporation I210 Gigabit Network Connection [8086:157b] (rev 03)
IOMMU Group 1 02:00.0 Ethernet controller [0200]: Intel Corporation I210 Gigabit Network Connection [8086:157b] (rev 03)
IOMMU Group 1 03:00.0 Ethernet controller [0200]: Intel Corporation I210 Gigabit Network Connection [8086:157b] (rev 03)
IOMMU Group 2 00:08.0 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Device [1022:1537]
IOMMU Group 3 00:10.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller [1022:7814] (rev 11)
IOMMU Group 4 00:11.0 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [IDE mode] [1022:7800] (rev 39)
IOMMU Group 5 00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller [1022:7808] (rev 39)
IOMMU Group 6 00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:780b] (rev 42)
IOMMU Group 6 00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:780e] (rev 11)
IOMMU Group 6 00:14.7 SD Host controller [0805]: Advanced Micro Devices, Inc. [AMD] FCH SD Flash Controller [1022:7813] (rev 01)
IOMMU Group 7 00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1580]
IOMMU Group 7 00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1581]
IOMMU Group 7 00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1582]
IOMMU Group 7 00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1583]
IOMMU Group 7 00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1584]
IOMMU Group 7 00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Device [1022:1585]
```

What bad here is that NICs are all in group 1. When we compared logs from
community it happen that some users with older patches had correct assignement,
for example [here](https://www.dropbox.com/s/nvme1ut0v65ou6r/dmesg_iommu_20171028.txt?dl=0):

```
[    2.047787] iommu: Adding device 0000:00:00.0 to group 0
[    2.053502] iommu: Adding device 0000:00:02.0 to group 1
[    2.059190] iommu: Adding device 0000:00:02.2 to group 2
[    2.064797] iommu: Adding device 0000:00:02.3 to group 3
[    2.070442] iommu: Adding device 0000:00:02.4 to group 4
[    2.076098] iommu: Adding device 0000:00:02.5 to group 5
[    2.081747] iommu: Adding device 0000:00:08.0 to group 6
[    2.087380] iommu: Adding device 0000:00:10.0 to group 7
[    2.093009] iommu: Adding device 0000:00:11.0 to group 8
[    2.098683] iommu: Adding device 0000:00:13.0 to group 9
[    2.104399] iommu: Adding device 0000:00:14.0 to group 10
[    2.109893] iommu: Adding device 0000:00:14.3 to group 10
[    2.115385] iommu: Adding device 0000:00:14.7 to group 10
[    2.121174] iommu: Adding device 0000:00:18.0 to group 11
[    2.126668] iommu: Adding device 0000:00:18.1 to group 11
[    2.132163] iommu: Adding device 0000:00:18.2 to group 11
[    2.137652] iommu: Adding device 0000:00:18.3 to group 11
[    2.143126] iommu: Adding device 0000:00:18.4 to group 11
[    2.148629] iommu: Adding device 0000:00:18.5 to group 11
[    2.154441] iommu: Adding device 0000:01:00.0 to group 12
[    2.160283] iommu: Adding device 0000:02:00.0 to group 13
[    2.166062] iommu: Adding device 0000:03:00.0 to group 14
[    2.171770] iommu: Adding device 0000:04:00.0 to group 15
```

There are many great resources to learn about IOMMU groups:

* [A Deep-dive into IOMMU Groups](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-iommu-deep-dive)
* [IOMMU Groups  What You Need to Consider](https://heiko-sieger.info/iommu-groups-what-you-need-to-consider/)

## Playing with xl pci-assignable-*

All commands from this family hangs, trying to enable pass-through using sysfs
seem to finish without problems. Didn't tested that yet.

## xendomains failed

```
● xendomains.service - LSB: Start/stop secondary xen domains
   Loaded: loaded (/etc/init.d/xendomains; generated; vendor preset: enabled)
   Active: failed (Result: timeout) since Thu 2018-08-02 21:13:41 UTC; 2min 22s 
     Docs: man:systemd-sysv-generator(8)
  Process: 452 ExecStart=/etc/init.d/xendomains start (code=killed, signal=TERM)
    Tasks: 1 (limit: 4915)
   CGroup: /system.slice/xendomains.service
           └─459 /usr/lib/xen-4.8/bin/xl list

Aug 02 21:08:41 apu2 systemd[1]: Starting LSB: Start/stop secondary xen domains.
Aug 02 21:13:41 apu2 systemd[1]: xendomains.service: Start operation timed out. 
Aug 02 21:13:41 apu2 systemd[1]: Failed to start LSB: Start/stop secondary xen d
Aug 02 21:13:41 apu2 systemd[1]: xendomains.service: Unit entered failed state.
Aug 02 21:13:41 apu2 systemd[1]: xendomains.service: Failed with result 'timeout
```

It looks like no Xen services were correctly loaded to Dom0:

```
  UNIT               LOAD   ACTIVE SUB    DESCRIPTION
● xen.service        loaded failed failed LSB: Xen daemons
● xendomains.service loaded failed failed LSB: Start/stop secondary xen domains

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

2 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

First create `/var/lib/xenstored`:

```
Aug 02 21:08:41 apu2 systemd[1]: xen.service: Control process exited, code=exited status=1
Aug 02 21:08:41 apu2 systemd[1]: Failed to start LSB: Xen daemons.
Aug 02 21:08:41 apu2 systemd[1]: xen.service: Unit entered failed state.
Aug 02 21:08:41 apu2 systemd[1]: xen.service: Failed with result 'exit-code'.
Aug 02 21:41:08 apu2 systemd[1]: Starting LSB: Xen daemons...
Aug 02 21:41:09 apu2 xenstored[702]: Checking store ...
Aug 02 21:41:09 apu2 xenstored[702]: Checking store complete.
Aug 02 21:41:09 apu2 xenstored[702]: Checking store ...
Aug 02 21:41:09 apu2 xen[678]: Starting Xen daemons: xenstoredWARNING: Failed to open connection to gnttab
Aug 02 21:41:09 apu2 xen[678]: FATAL: Failed to open evtchn device: No such file or directory
Aug 02 21:41:39 apu2 xen[678]:  failed!
Aug 02 21:41:39 apu2 systemd[1]: xen.service: Control process exited, code=exited status=1
Aug 02 21:41:39 apu2 systemd[1]: Failed to start LSB: Xen daemons.
Aug 02 21:41:39 apu2 systemd[1]: xen.service: Unit entered failed state.
Aug 02 21:41:39 apu2 systemd[1]: xen.service: Failed with result 'exit-code'.
```

After reinstalling recent kernel with more XEN drivers xen service starts
without problem.

# No irq handler

Sporadically we see issue like this:

```
(XEN) CPU1: No irq handler for vector e7 (IRQ -2147483648)
(XEN) CPU2: No irq handler for vector e7 (IRQ -2147483648)
<hang>
```

After long observation we think it can be related with our workflow. Typically
when we deploy new kernel, rootfs or firmware we just simply cut the power off
from machine where typically NFS-mounted Debian is running. This may lead to
some stalled connection on network device.

The problem appears always just once after kernel, rootfs or firmware update.
This happen always during first boot after update, further booting is not
affected.


# TODO:
- compare device entries
- enable EFRSup
- try various sets of features and capabilities
- install pfSense as HVM
