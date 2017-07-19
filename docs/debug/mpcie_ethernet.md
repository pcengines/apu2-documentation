### Intro

Device under test is mPCIe extension card with double Ethernet interfaces
exposed. Their MAC addresses are:

```
00:e0:4c:68:05:c8
00:e0:4c:68:05:c9
```

* Platform is APU2C4

* Firmware is
  [coreboot v4.5.8](https://github.com/pcengines/coreboot/tree/v4.5.8)
  from PC engines fork.

* Operating system is Voyage Linux. `uname -a` output:

```
Linux voyage 3.16.7-ckt9-voyage #1 SMP Wed Apr 22 23:04:57 HKT 2015 x86_64 GNU/Linux
```

### mPCIe slot 1 slot

#### Device identification

Ethernet interfaces from extension card are correctly detected:


```
ip a
```

output:

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c8 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.10/24 brd 10.0.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::2e0:4cff:fe68:5c8/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.120/24 brd 192.168.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::2e0:4cff:fe68:5c9/64 scope link
       valid_lft forever preferred_lft forever
4: eth2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bc brd ff:ff:ff:ff:ff:ff
    inet6 fe80::20d:b9ff:fe43:3fbc/64 scope link
       valid_lft forever preferred_lft forever
5: eth3: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bd brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.108/24 brd 192.168.0.255 scope global eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:b9ff:fe43:3fbd/64 scope link
       valid_lft forever preferred_lft forever
6: eth4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0d:b9:43:3f:be brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.112/24 brd 192.168.0.255 scope global eth4
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:b9ff:fe43:3fbe/64 scope link
       valid_lft forever preferred_lft forever
```

output:

```
lspci
```

```
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1566
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 156b
00:02.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.5 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:08.0 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device 1537
00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller (rev 11)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [IDE mode] (rev 39)
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller (rev 39)
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 42)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
00:14.7 SD Host controller: Advanced Micro Devices, Inc. [AMD] FCH SD Flash Controller (rev 01)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1580
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1581
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1582
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1583
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1584
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1585
01:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
02:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
03:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
04:00.0 PCI bridge: ASMedia Technology Inc. Device 1182
05:03.0 PCI bridge: ASMedia Technology Inc. Device 1182
05:07.0 PCI bridge: ASMedia Technology Inc. Device 1182
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ether)
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
```

Our extension card controllers are detected as follows:

```
lspci -v -s 06:00.00
```

output:

```
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
        Flags: bus master, fast devsel, latency 0, IRQ 75
        I/O ports at 1000 [size=256]
        Memory at f7800000 (64-bit, non-prefetchable) [size=4K]
        Memory at f7600000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
```

```
lspci -v -s 07:00.00
```

output:

```
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
        Flags: bus master, fast devsel, latency 0, IRQ 76
        I/O ports at 2000 [size=256]
        Memory at f7900000 (64-bit, non-prefetchable) [size=4K]
        Memory at f7700000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
```

#### Establishing connection

For the purpose of following test, automatic connection initialization was
disabled by erasing `/etc/network/interfaces` file content. No network manager
was present as well.

Available Ethernet interfaces list:

```
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c9 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bc brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bd brd ff:ff:ff:ff:ff:ff
6: eth4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:be brd ff:ff:ff:ff:ff:ff
```

* First interface (00:e0:4c:68:05:c9 MAC address) from extension card:

```
ifconfig eth1 up
```

output:

```
[  105.204628] r8169 0000:07:00.0: firmware: direct-loading firmware rtl_nic/rtl8168e-3.fw
[  105.313609] r8169 0000:07:00.0 eth1: link down
[  105.318155] r8169 0000:07:00.0 eth1: link down
[  105.318482] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[  107.209683] r8169 0000:07:00.0 eth1: link up
[  107.214014] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
```

```
dhclient eth1
ifconfig eth1
```

output:

```
eth1      Link encap:Ethernet  HWaddr 00:e0:4c:68:05:c9
          inet addr:192.168.0.120  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2e0:4cff:fe68:5c9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:22 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2945 (2.8 KiB)  TX bytes:2060 (2.0 KiB)
```

Pinging some internal or external addresses from APU2 works:

```
ping 192.168.0.1
```

output:

```
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.374 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.266
```

```
ping google.pl
```

output:

```
PING google.pl (172.217.20.195) 56(84) bytes of data.
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=1 ttl=57 time=6.52 ms
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=2 ttl=57 time=6.48 ms
```

Pinging `eth1` interface address from different PC works as well:

```
ping 192.168.0.120
```

output:

```
PING 192.168.0.120 (192.168.0.120) 56(84) bytes of data.
64 bytes from 192.168.0.120: icmp_seq=1 ttl=64 time=0.592 ms
64 bytes from 192.168.0.120: icmp_seq=2 ttl=64 time=0.482 ms
```

* Second interface (00:e0:4c:68:05:c8 MAC address) from extension card:

> Reboot was executed first.

```
ifconfig eth0 up
```

output:

```
[  218.000514] r8169 0000:06:00.0: firmware: direct-loading firmware rtl_nic/rtl8168e-3.fw
[  218.118256] r8169 0000:06:00.0 eth0: link down
[  218.122760] r8169 0000:06:00.0 eth0: link down
[  218.127347] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  220.014881] r8169 0000:06:00.0 eth0: link up
[  220.019250] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
```

```
dhclient  eth0
ifconfig eth0
```

output:

```
eth0      Link encap:Ethernet  HWaddr 00:e0:4c:68:05:c8
          inet addr:192.168.0.123  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2e0:4cff:fe68:5c8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3 errors:0 dropped:0 overruns:0 frame:0
          TX packets:9 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1240 (1.2 KiB)  TX bytes:1262 (1.2 KiB)
```

Pinging some internal or external addresses from APU2 works:

```
ping 192.168.0.1
```

output:

```
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.391 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.233 ms
```

```
ping google.pl
```

output:

```
PING google.pl (172.217.20.195) 56(84) bytes of data.
64 bytes from waw02s08-in-f3.1e100.net (172.217.20.195): icmp_seq=1 ttl=57 time=6.59 ms
64 bytes from waw02s08-in-f3.1e100.net (172.217.20.195): icmp_seq=2 ttl=57 time=6.44 ms
```

Pinging `eth0` interface address from different PC works as well:

```
PING 192.168.0.123 (192.168.0.123) 56(84) bytes of data.
64 bytes from 192.168.0.120: icmp_seq=1 ttl=64 time=0.592 ms
64 bytes from 192.168.0.120: icmp_seq=2 ttl=64 time=0.482 ms
```

### mPCIe slot 2

#### Device identification

Ethernet interfaces from extension card are not detected:

```
lspci
```

output:

```
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1566
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 156b
00:02.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:08.0 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device 1537
00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller (rev 11)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [IDE mode] (rev 39)
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller (rev 39)
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 42)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
00:14.7 SD Host controller: Advanced Micro Devices, Inc. [AMD] FCH SD Flash Controller (rev 01)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1580
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1581
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1582
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1583
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1584
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1585
01:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
02:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
03:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
```

```
ip a
```

output:


```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bc brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.135/24 brd 192.168.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:b9ff:fe43:3fbc/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bd brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.108/24 brd 192.168.0.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:b9ff:fe43:3fbd/64 scope link
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0d:b9:43:3f:be brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.112/24 brd 192.168.0.255 scope global eth2
       valid_lft forever preferred_lft forever
    inet6 fe80::20d:b9ff:fe43:3fbe/64 scope link
       valid_lft forever preferred_lft forever
```


### mPCIe slot 2 with clock always enabled

This is different from the previous one with the following change in source
code:

```
diff --git a/src/mainboard/pcengines/apu2/romstage.c b/src/mainboard/pcengines/apu2/romstage.c
index a1c73d1e3424..f018ac5742ce 100644
--- a/src/mainboard/pcengines/apu2/romstage.c
+++ b/src/mainboard/pcengines/apu2/romstage.c
@@ -99,7 +99,9 @@ void cache_as_ram_main(unsigned long bist, unsigned long cpu_init_detectedx)
                data = *((u32 *)(ACPI_MMIO_BASE + MISC_BASE+FCH_MISC_REG04));

                data &= 0xFFFFFF0F;
-               data |= 0xA << (1 * 4); // CLKREQ GFX to GFXCLK
+               // make GFXCLK to ignore CLKREQ# input
+               // force it to be always on
+               data |= 0xF << (1 * 4); // CLKREQ GFX to GFXCLK
```

#### Device identification

```
ip a
```

output:

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bc brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.10/24 brd 10.0.0.255 scope global eth0
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bd brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:be brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c8 brd ff:ff:ff:ff:ff:ff
6: eth4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c9 brd ff:ff:ff:ff:ff:ff
```

```
lspci
```

output:

```
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1566
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 156b
00:02.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:02.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 16h Processor Functions 5:1
00:08.0 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device 1537
00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI Controller (rev 11)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA Controller [IDE mode] (rev 39)
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI Controller (rev 39)
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 42)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 11)
00:14.7 SD Host controller: Advanced Micro Devices, Inc. [AMD] FCH SD Flash Controller (rev 01)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1580
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1581
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1582
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1583
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1584
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1585
01:00.0 PCI bridge: ASMedia Technology Inc. Device 1182
02:03.0 PCI bridge: ASMedia Technology Inc. Device 1182
02:07.0 PCI bridge: ASMedia Technology Inc. Device 1182
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ether)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ether)
05:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
06:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
07:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
```

Our extension card controllers are detected as follows:

```
lspci -v -s 03:00.00
```

output:

```
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
        Flags: bus master, fast devsel, latency 0, IRQ 76
        I/O ports at 1000 [size=256]
        Memory at f7800000 (64-bit, non-prefetchable) [size=4K]
        Memory at f7600000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
```

```
lspci -v -s 04:00.00
```

output:

```
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 06)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
        Flags: bus master, fast devsel, latency 0, IRQ 77
        I/O ports at 2000 [size=256]
        Memory at f7900000 (64-bit, non-prefetchable) [size=4K]
        Memory at f7700000 (64-bit, prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Endpoint, MSI 01
        Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
        Capabilities: [d0] Vital Product Data
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Virtual Channel
        Capabilities: [160] Device Serial Number 01-00-00-00-68-4c-e0-00
        Kernel driver in use: r8169
```

#### Establishing connection

For the purpose of following test, automatic connection initialization was
disabled by erasing `/etc/network/interfaces` file content. No network manager
was present as well.

Available Ethernet interfaces list:

```
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:e0:4c:68:05:c9 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bc brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:bd brd ff:ff:ff:ff:ff:ff
6: eth4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0d:b9:43:3f:be brd ff:ff:ff:ff:ff:ff
```

* First interface (00:e0:4c:68:05:c9 MAC address) from extension card:

> Reboot was executed first.

```
ifconfig eth1 up
```

output:

```
[  702.047648] r8169 0000:04:00.0: firmware: direct-loading firmware rtl_nic/rtl8168e-3.fw
[  702.161935] r8169 0000:04:00.0 eth1: link down
[  702.166586] r8169 0000:04:00.0 eth1: link down
[  702.166817] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[  704.076523] r8169 0000:04:00.0 eth1: link up
[  704.080905] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
```

```
dhclient eth1
ifconfig eth1
```

output:

```
eth1      Link encap:Ethernet  HWaddr 00:e0:4c:68:05:c9
          inet addr:192.168.0.120  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2e0:4cff:fe68:5c9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1300 (1.2 KiB)  TX bytes:1332 (1.3 KiB)
```

Pinging some internal or external adresses from APU2 works:

```
ping 192.168.0.1
```

output:

```
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.371 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.313 ms
```

```
ping google.pl
```

output:

```
PING google.pl (172.217.20.195) 56(84) bytes of data.
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=1 ttl=57 time=6.54 ms
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=2 ttl=57 time=6.46 ms
```

Pinging `eth1` interface address from different PC works well:

```
ping 192.168.0.120
```

output:

```
PING 192.168.0.120 (192.168.0.120) 56(84) bytes of data.
64 bytes from 192.168.0.120: icmp_seq=1 ttl=64 time=0.755 ms
64 bytes from 192.168.0.120: icmp_seq=2 ttl=64 time=0.306 ms
```

* Second interface (00:e0:4c:68:05:c8 MAC address) from extension card:

> Reboot was executed first.

```
ifconfig eth0 up
```

output:

```
[   63.775838] r8169 0000:03:00.0: firmware: direct-loading firmware rtl_nic/rtl8168e-3.fw
[   63.880564] r8169 0000:03:00.0 eth0: link down
[   63.885105] r8169 0000:03:00.0 eth0: link down
[   63.885192] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   65.798066] r8169 0000:03:00.0 eth0: link up
[   65.802396] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
```

```
dhclient  eth0
ifconfig eth0
```

output:

```
eth0      Link encap:Ethernet  HWaddr 00:e0:4c:68:05:c8
          inet addr:192.168.0.123  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::2e0:4cff:fe68:5c8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1300 (1.2 KiB)  TX bytes:1332 (1.3 KiB)
```

Pinging some internal or external adresses from APU2 works:

```
ping 192.168.0.1
```

output:

```
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.750 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.266 ms
```

```
ping google.pl
```

output:

```
PING google.pl (172.217.20.195) 56(84) bytes of data.
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=1 ttl=57 time=6.87 ms
64 bytes from waw02s08-in-f195.1e100.net (172.217.20.195): icmp_seq=2 ttl=57 time=6.75 ms
```

Pinging `eth0` interface address from different PC works well:

```
ping 192.168.0.123
```

output:

```
PING 192.168.0.123 (192.168.0.123) 56(84) bytes of data.
64 bytes from 192.168.0.123: icmp_seq=1 ttl=64 time=0.800 ms
64 bytes from 192.168.0.123: icmp_seq=2 ttl=64 time=0.313 ms
```

### Conclusion

* Ethernet interfaces from extension card inserted into mPCIe slot 1 operate
  properly in terms of device enumeration and DHCP lease.

* Ethernet interfaces from extension card inserted into mPCIe slot 2 do not
  operate properly. They are not enumerated by kernel.

* After forcing mPCIe clock to be always on, Ethernet interfaces from extension
  card inserted into mPCIe 2 slot operate in the same fashion as when inserted
  into mPCIe slot 1 (when it comes to device enumeration and DHCP lease, at
  least). Note that
  [corresponding change](https://github.com/pcengines/coreboot/blob/v4.5.8/src/mainboard/pcengines/apu2/romstage.c#L95)
  exists for mPCIe slot 1.
