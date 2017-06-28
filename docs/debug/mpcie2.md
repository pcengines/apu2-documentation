ASM1061 in the J13 slot problems
================================

## Rationale

mPCIe 2 slot (J13) on APU2 devices has problems, when ASM1061 controllers are
used. With disk connected, device enters bootloop and never boots. When no disks
are connected, system boots normally and controller is detectable using `lspci`.

Another problem is, that normally ASM1061 contoller on the mPCIe board like,
e.g. this [Delock adapter], is not detectable in mPCIe 2 slot at all. One need
to modify the `apu2/romstage.c` file and enable always on Clock for GFX PCIE
slot, like this (in `cache_as_ram_main` function, after clock are set, see
[here](https://github.com/pcengines/coreboot/blob/coreboot-4.5.x/src/mainboard/pcengines/apu2/romstage.c#L95)
for reference):

```c
		data = *((u32 *)(ACPI_MMIO_BASE + MISC_BASE + FCH_MISC_REG04));

		data &= 0xFFFFFF0F;
		data |= 0xF << (1 * 4);	// CLKREQ GFX always on.

		*((u32 *)(ACPI_MMIO_BASE + MISC_BASE + FCH_MISC_REG04)) = data;
```

> See in [BKDG] paragraph 3.26.11: `MISCx04 ClkOutputCntrl` register

## Symptoms

Currently after connecting disk - enters boot loop.

Problem occurs in SeaBIOS's AHCI driver. `ahci_port_detect` routine/thread.

AHCI reports `PORT_IRQ_IF_ERR` or `PORT_IRQ_IF_NONFATAL` errors:
> According to [AHCI spec], paragraph 3.3.5

```
|cff47000| AHCI/1: ... intbits 0x8000002, status 0x58 ..

... or ...

|cff47000| AHCI/1: ... intbits 0x40000001, status 0x51 ..
```

Reset happens just after setting transfer mode command is sent.
I've tried setting UDMA, MultiDMA or PIO modes and it's still the same (reset).

```
|cff47000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
|cff47000| AHCI/1: Set transfer mode to default PIO
|cff47000| AHCI/1: send cmd ...
|cff47000| AHCI/1: ... intbits 0x1, status 0x50, err 0x0 ...
|cff47000| AHCI/1: ... finished, status 0x50, OK

# reset happens always here
```

[Delock adapter]: http://www.delock.de/produkte/F_428_Mini-PCI-Express_95233/merkmale.html
[BKDG]: http://support.amd.com/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf
[AHCI spec]:https://www.intel.com/content/www/us/en/io/serial-ata/serial-ata-ahci-spec-rev1-3-1.html
