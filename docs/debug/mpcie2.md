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

```
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

## Carried out tests

Testing ASM1061 was performed for 2 types of Delock 95233 modules:
- module with soldered R58&sup1; resistor
- modified module without R58&sup1; resistor

(1) R58 resistor is placed next to CON1 connector

Test results are the same for both types of modules and as follows:

1. Delock module is attached to mPCIe2 slot and SATA disk is connected before
    platform boot process.

    In that case boot process went into 'infinite boot loop'. It went to payload
    menu, hanged and after few seconds performed reboot automatically. During
    booting, user can't do any action. There are no response from apu platform to
    any button pressing. Only option to went through boot process without troubles
    is to disconnect SATA disk and reboot platform again.

2. Delock module is attached to mPCIe2 slot, but no SATA disk is connected
    before and during platform boot process.

    Boot process goes smoothly to seaBIOS menu and OS booting was performed
    correctly also. Under Debian OS, ASM controller is detected (check it with
    e.g. `dmesg | grep "ahci"`.

    ```
    root@debian:~# dmesg | grep "ahci"
    [    9.370761] ahci 0000:00:11.0: version 3.0
    [    9.371737] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
    [    9.380220] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp fbs pio slum part ccc
    [    9.389294] ahci 0000:00:11.0: both AHCI_HFLAG_MULTI_MSI flag set and custom irq handler implemented
    [    9.401327] scsi host0: ahci
    [    9.407101] scsi host1: ahci
    [    9.432821] ahci 0000:01:00.0: SSS flag set, parallel bus scan disabled
    [    9.564657] ahci 0000:01:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
    [    9.572796] ahci 0000:01:00.0: flags: 64bit ncq sntf stag led clo pmp pio slum part ccc sxs
    [    9.583302] scsi host2: ahci
    [    9.586835] scsi host3: ahci

    ```
    Ahci 0000:01:00.0 is Dealock 95233 SATA controller.

    After plugged-in SATA disk (no matter to what SATA port), configuration
    problems appeared. Although, OS was trying to communicate with SATA, some
    warnings and errors occurred. Example log is shown below.

    ```
    [   68.190693] ata3: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
    [   68.198142] ata3: irq_stat 0x00000040, connection status changed
    [   68.204199] ata3: SError: { CommWake DevExch }
    [   68.208743] ata3: hard resetting link
    [   73.826743] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
    [   73.839192] ata3.00: ATA-8: ST500LM012 HN-M500MBB, 2AR10002, max UDMA/133
    [   73.846011] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
    [   73.859579] ata3.00: configured for UDMA/133
    [   73.863903] ata3: EH complete
    [   73.867515] scsi 2:0:0:0: Direct-Access     ATA      ST500LM012 HN-M5 0002 PQ: 0 ANSI: 5
    [   73.876569] sd 2:0:0:0: Attached scsi generic sg1 type 0
    [   73.876592] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/466 GiB)
    [   73.876597] sd 2:0:0:0: [sdb] 4096-byte physical blocks
    [   73.876665] sd 2:0:0:0: [sdb] Write Protect is off
    [   73.876827] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    [   73.941291]  sdb: sdb1 sdb2 < sdb5 >
    [   73.946498] sd 2:0:0:0: [sdb] Attached SCSI disk
    ```

Pay attention that some data is sent correctly between controller and OS (e.g.
HDD disk information or configuration). However, platform hanged in that stage
and didn't respond to any command. Therefore, faultless connection can't be
established and HDD disk plugged via Delock module can't be treated as working.

## Possible reasons

It looks like problem can be considered rather as hardware. Also it is Delock
95233 module/ASM1061 controller problem. Tested SATA disk works fine when
attached to SATA connector on apu2 board. After searching solutions, 2 main
appears as most useful:

- Power supply is not sufficient and drops out to too low level. However, tested
disk was powered with around 5V. Problems with power supply drop out occurred
in some  SATA disk, but mostly are related to 12V disks

- Low quality cables and connectors on Delock module

Both solutions haven't been tested yet. But it looks like they should be
considered and carried out.

[Delock adapter]: http://www.delock.de/produkte/F_428_Mini-PCI-Express_95233/merkmale.html
[BKDG]: http://support.amd.com/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf
[AHCI spec]:https://www.intel.com/content/www/us/en/io/serial-ata/serial-ata-ahci-spec-rev1-3-1.html
