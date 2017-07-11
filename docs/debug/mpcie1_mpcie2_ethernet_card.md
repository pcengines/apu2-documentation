Problems with APU2 when using Mini PCI-Express Dual Gigabit Ethernet Controller Card
====================================================================================

## Problems

1. When Ethernet Controller Card is placed in mPCIe1 slot (J14) placed extension cards 
is recognized by OS but standard Ethernet output placed on APU2 board can't receive 
correct IP adress. So it doesn't work correct. 

2. When Ethernet Controller Card is placed in mPCIe2 slot (J13) 2 additional Ethernet 
controller are not visible in OS. Standard Ethernet output placed on APU2 board 
works well.

> Device detection has been checked using `ip a`, `lspci` and `dmesg`. The results are 
shown in the table below.

```
	+-----+-----------------------------+
	| dev |          visibility         |
	+-----+--------------+--------------+
	| eth | mPCIe1 (J14) | mPCIe2 (J13) |
	+-----+--------------+--------------+
	|  0  |     yes      |     yes      |
	|  1  |     yes      |     yes      |
	|  2  |     yes      |     yes      |
	|  3  |     yes      |     no       |
	|  4  |     yes      |     no       |
	+--------------------+--------------+
```

## Mini PCI-Express Dual Gigabit Ethernet Controller Card elements

On a board are located PCI bridge [ASMedia Technology Inc. Device 1182](http://www.asmedia.com.tw/eng/e_show_products.php?cate_index=112&item=134) and 2 Ethernet 
controllers [Realtek Semiconductor Co., Ltd. RTL8111/8168/8411](http://www.realtek.com/products/productsView.aspx?Langid=1&PNid=13&PFid=5&Level=5&Conn=4).

## Booting lags

When Ethernet Controller is placed in the mPCIe1 slot (J14) and booting is at network 
devices setup time occurs long lag. In this case `eth0` device can not get correct IP. 
After this next booting processes take same normal time. The reason may be multiple 
failed attempts to obtain an IP address.
That problem doesn't exist for the mPCIe2 slot (J13).

## Boot logs comparison

Level of the detail of booting logs was set at `6:DEBUG`.

> The full list varies between logs is placed at the end file.

The most suspicious difference in logs is placed below.

For `mPCIe2`:

```	
	PCI: Static device PCI: 00:02.5 not found, disabling it.
```
For `mPCIe1`:

```
	PCI: 00:02.5 subordinate bus PCI Express
	PCI: 00:02.5 [1022/1439] enabled
```

This suggests a problem with device recognition when Ethernet Controller is 
placed in the mPCIe1 slot (J14). The reason for this can be rivalry of devices
or incorrect designed interrupt system.

Surrounding the log of the case when Ethernet Controller is placed in the mPCIe1 
slot (J14).

```
	scan_bus: scanning of bus CPU_CLUSTER: 0 took 15987 usecs
	PCI: pci_scan_bus for bus 00
	PCI: 00:00.0 [1022/1566] enabled
	PCI: 00:02.0 [1022/156b] enabled
	PCI: Static device PCI: 00:02.1 not found, disabling it.
	PCI: 00:02.2 subordinate bus PCI Express
	PCI: 00:02.2 [1022/1439] enabled
	PCI: 00:02.3 subordinate bus PCI Express
	PCI: 00:02.3 [1022/1439] enabled
	PCI: 00:02.4 subordinate bus PCI Express
	PCI: 00:02.4 [1022/1439] enabled
	PCI: Static device PCI: 00:02.5 not found, disabling it.
	PCI: 00:08.0 [1022/1537] enabled
	hudson_enable()
	PCI: 00:10.0 [1022/7814] enabled
	hudson_enable()
```

Situation occurs at the moment when PCI bus is being scanned.

## Checked potencial reasons

Several possible reasons for problems have been checked, but the problems continued.

1. Tried to modify `apu2/PlatformGnbPcie.c` file like below.


```c
	   -PCIE_ENGINE_DATA_INITIALIZER (PciePortEngine, 4, 7),
	   +PCIE_ENGINE_DATA_INITIALIZER (PciePortEngine, 4, 4),
```

After modification system worked as before. The problems still occur.

2. Measured voltages at `CLKREQ4#`and `PE4RST#` pins. All the time there was occurring 
high states for listed pins.

> Voltage at `CLKREQ4#` was about 0.02 V lower than expansion Ethernet controller card 
power supply voltage and voltage at `PE4RST#` was about 0.02 V higher than Ethernet 
controller card power supply voltage. The difference can be considered a measurement error.

## Diff files from boot logs

Full diff files from APU2 boot logs between Ethernet Controller placed in the mPCIe1 slot (J14)
and it placed in mPCIe2 slot (J13):

[diff of boot logs](http://81.95.197.197:7777/duzixebaqi.md)
[diff of ip a command logs](http://81.95.197.197:7777/woseyetaxu.hs)
[diff of lspcie command logs](http://81.95.197.197:7777/gozepejoja.go)
[diff of lsusb command logs](http://81.95.197.197:7777/zecidunudi.css)
