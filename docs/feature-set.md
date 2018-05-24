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
| Serial console enable/disable | YES`*` |
| SIMSWAPs | YES`***` |
| SMBIOS table short partnumber | YES |

`*` - apu5 has no support for S1
`**` - only mainline releases
`***` - apu3 seems to have inverted functionality

# SeaBIOS features

| Feature | Supported |
|---------|-----------|
| OHCI/UHCI disabled | YES |
| ATA UDMA | YES |
| Boot menu timeout 6s | YES |
| F10 button to enter boot menu | YES |
| Custom boot menu string | YES |
| N for PXe boot string | YES |
| PXE shadowing | YES |
| USB boot shadowing | YES |
| USB xHCI timing adjustments | YES`*` |
| Serial console enable/disable | YES`**` |
| Bootorder configuration file | YES |
| Sercon-port configuration file | YES |

`*` - some sticks seem to not work still, additionally apu4 has problems with
two sticks simultaneously plugged
`**` - apu5 do not yet support serial console enable

# iPXE features

| Feature | Supported |
|---------|-----------|
| Output not duplicated | YES |
| Custom iPXE menu | YES |

# Memtest86+ features

| Feature | Supported |
|---------|-----------|
| Correct SMBus base | YES`*` |
| Screen refresh | YES |

`*` - SMBus base is correct for apu2 series, Memtest86+ hangs on apu1

# Sortbootorder features

| Feature | Supported |
|---------|-----------|
| Setting bootorder priority | YES |
| PXE boot enable/disable | YES |
| USB boot enable/disable | YES |
| Serial console enable/disable | YES |
| UARTc/d enable/disable | YES |
| Force mPCIe2 clk | YES |
| BIOS WP enable/disable | YES |
| Restore default options | YES |
| EHCI0 enable/disable | YES |
| Bootorder is aligned correctly | YES |
