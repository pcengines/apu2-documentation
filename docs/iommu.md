AMD I/O Virtualization Technology (IOMMU)
=========================================

This document is related to changes submitted to [mainline coreboot](https://review.coreboot.org/#/c/coreboot/+/26116/).

# Status

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
ivrs_agesa->ivhd.flags: 0xfe
ivrs_agesa->ivhd.length: 0x48
ivrs_agesa->ivhd.device_id: 0x2
ivrs_agesa->ivhd.capability_offset: 0x40
ivrs_agesa->ivhd.iommu_base_low: 0xf7f00000
ivrs_agesa->ivhd.iommu_base_high: 0x0
ivrs_agesa->ivhd.pci_segment_group: 0x0
ivrs_agesa->ivhd.iommu_info: 0x1300
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
ivrs->ivhd.flags: 0x1e
ivrs->ivhd.length: 0xd0
ivrs->ivhd.device_id: 0x2
ivrs->ivhd.capability_offset: 0x40
ivrs->ivhd.iommu_base_low: 0xfeb00000
ivrs->ivhd.iommu_base_high: 0x0
ivrs->ivhd.pci_segment_group: 0x0
ivrs->ivhd.iommu_info: 0x1300
ivrs->ivhd.iommu_feature_info: 0x0
```
