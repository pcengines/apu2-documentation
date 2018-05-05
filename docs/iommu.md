AMD I/O Virtualization Technology (IOMMU)
-----------------------------------------

This document is related to changes submitted to [mainline coreboot](https://review.coreboot.org/#/c/coreboot/+/26116/).

# Status

* patches submitted upstream
* patches included in v4.6.9 of PC Engined firmware release
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

# How to check features with Xen

Please [read this blog post](TBD)

# How to test IOMMU features

## PCE pass-through

TBD
