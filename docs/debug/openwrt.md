Openwrt booting from SD card issue
==================================

Customer reported that Openwrt is not booting from SD card. It boot from the USB
drive though. After investigating this issue the conclusion is lack of SD
controller driver in default kernel coming with this distribution.

The problem
-----------

Excerpt from the message from customer:

Openwrt boots fine from USB on APU2 and from USB/SD on APU1.
Boot from SD on APU2 hangs after `switched to clocksource tsc` message.

```
...
[    2.419743] TCP: cubic registered
[    2.423086] NET: Registered protocol family 17
[    2.427641] bridge: automatic filtering via arp/ip/ip6tables has
been deprecated. Update your scripts to load br_netfilter if you need
this.
[    2.440287] 8021q: 802.1Q VLAN Support v1.8
[    2.444626] NET: Registered protocol family 40
[    2.451229] rtc_cmos 00:01: setting system clock to 2016-03-07
01:30:05 UTC (1457314205)
[    2.459720] Waiting for root device PARTUUID=87cf4590-02...
[    2.672327] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    2.822997] hub 3-1:1.0: USB hub found
[    2.827164] hub 3-1:1.0: 4 ports detected
[    2.972522] Switched to clocksource tsc
```

The solution
------------

### Symptoms

* After inserting the USB drive with the same image as on SD card OS continues
  to boot.
* `/dev/mmcblk0*` devices are not present.

### Resolution

Openwrt boots normally after using the kernel with compiled in `sdhci-pci`
driver (in default kernels this module is disabled).
For Openwrt Buildroot's:
* `make menuconfig`
* setup openwrt for target __x86__, subtarget __x86_64__
* in __Target Images__ check __ext4__ and __Build GRUB images
  (Linux x86 or x86_64 host only)__
* `make kernel_menuconfig` - could not work at first try.
  Try running `make target/linux/prepare` or `make target/linux/compile` first.
* go into `Device Drivers → MMC/SD/SDIO`
* enable `MMC block device driver`, `Secure Digital Host Controller Interface
  support`, `SDHCI support on PCI bus`
* commence normal build (`make`)

Tested on `chaos_calmer` branch from https://github.com/openwrt/openwrt.
