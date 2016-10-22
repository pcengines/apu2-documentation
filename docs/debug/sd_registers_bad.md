### Change SD controller registers

BAD card acts like there is no card (logs `BAD from cold boot` vs `no card
and Card Detect tied to ground` are the same in terms of command flow)

Results of below test are the same: GOOD appears in bootmenu after coldboot, BAD doesn't.

SDHC registers values in release v4.0.1.1:

```
		pci_write_config32(dev, 0xA4, 0x21FE32B2); //0b 0010 0001 1101 1110 0011 0010 1011 0010
		pci_write_config32(dev, 0xA8, 0x00000070); //0b 0000 0000 0000 0000 0000 0000 0111 0000
		pci_write_config32(dev, 0xB0, 0x01180C01); //0b 0000 0001 0001 1000 0000 1100 0000 0001
		pci_write_config32(dev, 0xD0, 0x0000078B); //0b 0000 0000 0000 0000 0000 0111 1000 1011
```

1. Change from `Removable card slot` to `Embedded slot for one device`

		pci_write_config32(dev, 0xA4, 0x61FE32B2); //0b 0110 0001 1111 1110 0011 0010 1011 0010

2. Disable: Suspend/resume support, DMA support, High speed support, ADMA
   support, ADMA2 support, MMC8-bit support

		pci_write_config32(dev, 0xA4, 0x210232B2); //0b 0010 0001 0000 0010 0011 0010 1011 0010

3. Combination of 1. and 2. (disabled features and `embedded slot`)

		pci_write_config32(dev, 0xA4, 0x610232B2); //0b 0110 0001 0000 0010 0011 0010 1011 0010

4. Disabled features and `Shared Bus Slot` instead:

		pci_write_config32(dev, 0xA4, 0xA10232B2); //0b 1010 0001 0000 0010 0011 0010 1011 0010

5. Disabled features +  `TimeOut clock from internal`

		pci_write_config32(dev, 0xA4, 0xA1023232); //0b 1010 0001 0000 0010 0011 0010 0011 0010

6. Change `TmoFreq` from 0x32 to 0x02:

		pci_write_config32(dev, 0xA4, 0xA1023202); //0b 1010 0001 0000 0010 0011 0010 0000 0010

7. Disable features from `0xB0` register: Memory deep sleep mode, memory shutdown
   mode, Master Read prefetch:

		pci_write_config32(dev, 0xB0, 0x01180000); //0b 0000 0001 0001 1000 0000 0000 0000 0000

8. Force 3.3V:

		pci_write_config32(dev, 0xD0, 0x0004078B); //0b 0000 0000 0000 0100 0000 0111 1000 1011


9. SD Power pin disable:

		pci_write_config32(dev, 0xD0, 0x0004070B);

Voltage on TP27 drops from 3.3V to 0.25V

10. Change driver strength value:

Initially `0xB8` register value was:

```
REGISTER B8  = 0x88000400
```
two first bytes are:

```
Specifies the SN driver strength value for 3.3V.
Specifies the SP driver strength value for 3.3V.
```

changes:

```
		pci_write_config32(dev, 0xB8, 0xFF000400);
		pci_write_config32(dev, 0xB8, 0xAA000400);
		pci_write_config32(dev, 0xB8, 0x55000400);
		pci_write_config32(dev, 0xB8, 0x00000400);
```
