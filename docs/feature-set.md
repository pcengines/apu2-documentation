PC Engines apu feature set
==========================

## Coreboot features

| Feature | Supported |
|---------|-----------|
| CBFS option mCPIe2 clk| YES |
| CBFS option EHCI0 | YES |
| CBFS option console | YES |
| CBFS option UARTc/d | YES |
| Serial number from NIC | YES |
| Serial number from SPI flash | YES |
| S1 button | NO`*` |
| SATA AHCI | YES `**` |
| Serial console enable/disable | YES |
| SIMSWAPs | YES`***` |
| SMBIOS table short partnumber |  |

`*` - apu5 has no support for S1
`**` - only mainline releases
`***` - apu3 seems to have inverted functionality

# SeaBIOS features

| Feature | Supported |
|---------|-----------|
| OHCI/UHCI disabled |  |
| ATA UDMA |  |
| Boot menu timeout 6s |  |
| F10 button to enter boot menu |  |
| Custom boot menu string |  |
| N for PXe boot string |  |
| PXE shadowing |  |
| USB boot shadowing |  |
| USB xHCI timing adjustments |  |
| Serial console enable/disable |  |
| Bootorder configuration file |  |
| Sercon-port configuration file |  |

# iPXE features

| Feature | Supported |
|---------|-----------|
| Output not duplicated |  |
| Custom iPXE menu |  |

# Memtest86+ features

| Feature | Supported |
|---------|-----------|
| Correct SMBus base |  |
| Screen refresh |  |

# Sortbootorder features

| Feature | Supported |
|---------|-----------|
| Setting bootorder priority |  |
| PXE boot enable/disable |  |
| USB boot enable/disable |  |
| Serial console enable/disable |  |
| UARTc/d enable/disable |  |
| Force mPCIe2 clk |  |
| BIOS WP enable/disable |  |
| Restore default options |  |
| EHCI0 enable/disable |  |
| Bootorder is aligned correctly |  |
