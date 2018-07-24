AMD I/O Virtualization Technology (IOMMU)
=========================================

This document is related to changes submitted to [mainline coreboot](https://review.coreboot.org/#/c/coreboot/+/26116/).

# Status

# 24/07/2018

* patches under redesign in upstream
* planned firmware release to include patches v4.8.0.3
* tested on Xen 4.8.3 and Debian stretch with Linux 4.14.50
* `xl dmesg` dump with apic and iommu verbose [here](logs/iommu_enabled_xl_dmesg.log)
* `CPUX: No irq handler for vector e7` log is still visible, but doesn't affect
boot process. We look for solution for that log [here](https://github.com/pcengines/coreboot/pull/186)
* platform survived 100x reboots to Xen without issue

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

TBD

Debugging
---------

Unfortunately previous work was not stable and according to comments from
Kyosti correct implementation should rely not on AGESA returned values, but on
custom IVRS generated in coreboot - this is approach that Timothy took
developing initial support.

Dump of IVRS from AGESA and custom made in above mentioned implemntation:

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

# TODO:
- compare device entries
- enable EFRSup
- try various sets of features and capabilities
