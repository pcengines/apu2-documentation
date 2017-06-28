ASM1062 in the J13 slot problems
================================

## Rationale

mPCIe 2 slot (J13) on APU2 devices has problems, when ASM1062 controllers are
used. With disk connected, device enters bootloop and never boots. When no disks
are connected, system boots normally and controller is detectable using `lspci`.

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

[AHCI spec]:https://www.intel.com/content/www/us/en/io/serial-ata/serial-ata-ahci-spec-rev1-3-1.html
