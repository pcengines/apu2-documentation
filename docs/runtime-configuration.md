# Runtime configuration

The apu platforms firmware contain an application called sortbootorder which
serves as a BIOS setup application. It allows to modify behavior of the
coreboot firmware and enable or disable features/peripherals.

For more information about the usage of sortbootorder application refer to
sortbootorder [README](https://github.com/pcengines/sortbootorder/blob/master/README.md).

## Offline runtime configuration

An application to modify the runtime configuration of apu platforms has been
developed. The source code is available at [PC Engines GitHub repository](https://github.com/pcengines/cb-order).

This application allows modifications of runtime configuration options on a
coreboot binary without the need of rebooting the platform and entering setup
menu via BIOS (which requires serial console). The application offers either a
user-friendly GUI or command line interface for scripting and automation.
Please refer to the [application's README](https://github.com/pcengines/cb-order/blob/master/README.md)
for the building process and dependencies.

For the usage you may execute `cb-order -h`.

Example command line usage:
`cb-order coreboot.rom -b iPXE,SATA -o usben=off -o watchdog=300`

This command moves iPXE and SATA boot options to the 1st and 2nd positions
respectively displacing other options from those positions. Additionally it
disables booting from USB and sets the watchdog to 300 seconds.

To achieve the same result using GUI simply run `cb-order coreboot.rom` to open
the GUI.

```
┌─ coreboot configuration :: apu4_v4.15.0.1.rom ───────────────────────────────┐
│                                                                              │
│ (B)  Edit boot order                                                         │
│ (O)  Edit options                                                            │
│ (S)  Save & Exit                                                             │
│ (X)  Exit                                                                    │
│                                                                              │
│ Down/j, Up/k         move cursor                                             │
│ Home/g, End          move cursor                                             │
│ Enter/Right/l/(key)  run current item                                        │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

The first submenu (`Shift+B`) allows to change the boot order of the devices in
SeaBIOS:

```
┌─ coreboot configuration :: boot order ───────────────────────────────────────┐
│                                                                              │
│ (A)  USB                                                                     │
│ (B)  SDCARD                                                                  │
│ (C)  mSATA                                                                   │
│ (D)  SATA                                                                    │
│ (E)  mPCIe1 SATA1 and SATA2                                                  │
│ (F)  iPXE                                                                    │
│                                                                              │
│ Down/j, Up/k        move cursor                                              │
│ Home/g, End         move cursor                                              │
│ PgDown/Ctrl+N       move record down                                         │
│ PgUp/Ctrl+P         move record up                                           │
│ (key)               move record to current position                          │
│ Backspace/Left/q/h  leave                                                    │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

To change the boot order to iPXE then SATA, first navigate to the `(A) USB` then
press the `Shift + F` key to move the iPXE to the first priority:

```
┌─ coreboot configuration :: boot order ───────────────────────────────────────┐
│                                                                              │
│ (A)  iPXE                                                                    │
│ (B)  USB                                                                     │
│ (C)  SDCARD                                                                  │
│ (D)  mSATA                                                                   │
│ (E)  SATA                                                                    │
│ (F)  mPCIe1 SATA1 and SATA2                                                  │
│                                                                              │
│ Down/j, Up/k        move cursor                                              │
│ Home/g, End         move cursor                                              │
│ PgDown/Ctrl+N       move record down                                         │
│ PgUp/Ctrl+P         move record up                                           │
│ (key)               move record to current position                          │
│ Backspace/Left/q/h  leave                                                    │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

Then move to the second position, i.e. `(B) USB` and press `Shift + E` to move
SATA to the second priority:

```
┌─ coreboot configuration :: boot order ───────────────────────────────────────┐
│                                                                              │
│ (A)  iPXE                                                                    │
│ (B)  SATA                                                                    │
│ (C)  USB                                                                     │
│ (D)  SDCARD                                                                  │
│ (E)  mSATA                                                                   │
│ (F)  mPCIe1 SATA1 and SATA2                                                  │
│                                                                              │
│ Down/j, Up/k        move cursor                                              │
│ Home/g, End         move cursor                                              │
│ PgDown/Ctrl+N       move record down                                         │
│ PgUp/Ctrl+P         move record up                                           │
│ (key)               move record to current position                          │
│ Backspace/Left/q/h  leave                                                    │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

Now that the boot order is set press one of the Backspace/Left/q/h to go back
to main menu. Then press `Shift + O` to open the runtime configuration options
submenu:

```
┌─ coreboot configuration :: options ──────────────────────────────────────────┐
│                                                                              │
│ (L)  [boosten     =     on]  Core Performance Boost                          │
│ (K)  [com2en      =    off]  Redirect console output to COM2                 │
│ (H)  [ehcien      =     on]  EHCI0 controller                                │
│ (V)  [iommu       =    off]  IOMMU                                           │
│ (M)  [mpcie2_clk  =    off]  Force mPCIe2 slot CLK (GPP3 PCIe)               │
│ (Y)  [pciepm      =    off]  PCIe power management features                  │
│ (G)  [pciereverse =    off]  Reverse order of PCI addresses                  │
│ (N)  [pxen        =    off]  Network (PXE boot)                              │
│ (T)  [scon        =     on]  Serial console                                  │
│ (J)  [sd3mode     =    off]  SD 3.0 mode                                     │
│ (O)  [uartc       =   UART]  UART C / GPIO[0..7]                             │
│ (P)  [uartd       =   UART]  UART D / GPIO[10..17]                           │
│ (U)  [usben       =     on]  USB boot                                        │
│ (I)  [watchdog    =      0]  Watchdog                                        │
│                                                                              │
│ Down/j, Up/k               move cursor                                       │
│ Home/g, End                move cursor                                       │
│ Space/Enter/Right/l/(key)  toggle/set option                                 │
│ Backspace/Left/q/h         leave                                             │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

Now let's use an alternative method of navigation with arrows and Space/Enter
keys. Use arrows to move to `usben` option and press Enter or Space to disable
it:

```
┌─ coreboot configuration :: options ──────────────────────────────────────────┐
│                                                                              │
│ (L)  [boosten     =     on]  Core Performance Boost                          │
│ (K)  [com2en      =    off]  Redirect console output to COM2                 │
│ (H)  [ehcien      =     on]  EHCI0 controller                                │
│ (V)  [iommu       =    off]  IOMMU                                           │
│ (M)  [mpcie2_clk  =    off]  Force mPCIe2 slot CLK (GPP3 PCIe)               │
│ (Y)  [pciepm      =    off]  PCIe power management features                  │
│ (G)  [pciereverse =    off]  Reverse order of PCI addresses                  │
│ (N)  [pxen        =    off]  Network (PXE boot)                              │
│ (T)  [scon        =     on]  Serial console                                  │
│ (J)  [sd3mode     =    off]  SD 3.0 mode                                     │
│ (O)  [uartc       =   UART]  UART C / GPIO[0..7]                             │
│ (P)  [uartd       =   UART]  UART D / GPIO[10..17]                           │
│ (U)  [usben       =    off]  USB boot                                        │
│ (I)  [watchdog    =      0]  Watchdog                                        │
│                                                                              │
│ Down/j, Up/k               move cursor                                       │
│ Home/g, End                move cursor                                       │
│ Space/Enter/Right/l/(key)  toggle/set option                                 │
│ Backspace/Left/q/h         leave                                             │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

Now to set the watchdog navigate down to watchdog option and press Space or Enter.
A new window will appear with a prompt to enter the number of seconds:

```
┌─ coreboot configuration :: options :: Watchdog ──────────────────────────────┐
│                                                                              │
│ New value:                                                                   │
│                                                                              │
│ Range: [0; 65535]                                                            │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

Type 300 and press enter to submit the value. The application should go back to
options submenu with the updated watchdog timeout:

```
┌─ coreboot configuration :: options ──────────────────────────────────────────┐
│                                                                              │
│ (L)  [boosten     =     on]  Core Performance Boost                          │
│ (K)  [com2en      =    off]  Redirect console output to COM2                 │
│ (H)  [ehcien      =     on]  EHCI0 controller                                │
│ (V)  [iommu       =    off]  IOMMU                                           │
│ (M)  [mpcie2_clk  =    off]  Force mPCIe2 slot CLK (GPP3 PCIe)               │
│ (Y)  [pciepm      =    off]  PCIe power management features                  │
│ (G)  [pciereverse =    off]  Reverse order of PCI addresses                  │
│ (N)  [pxen        =    off]  Network (PXE boot)                              │
│ (T)  [scon        =     on]  Serial console                                  │
│ (J)  [sd3mode     =    off]  SD 3.0 mode                                     │
│ (O)  [uartc       =   UART]  UART C / GPIO[0..7]                             │
│ (P)  [uartd       =   UART]  UART D / GPIO[10..17]                           │
│ (U)  [usben       =    off]  USB boot                                        │
│ (I)  [watchdog    =    300]  Watchdog                                        │
│                                                                              │
│ Down/j, Up/k               move cursor                                       │
│ Home/g, End                move cursor                                       │
│ Space/Enter/Right/l/(key)  toggle/set option                                 │
│ Backspace/Left/q/h         leave                                             │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

We are done now with all our modifications. Press one of the Backspace/Left/q/h
to go back to main menu. Then press `Shift + S` to save changes to the binary
and the application will exit. Now you can flash the firmware update on your
platform like described [here](firmware_flashing.md#corebootrom-flashing).

## Persistent runtime configuration

Since the v4.14.0.1 release the runtime configuration options have been
separated from coreboot code in different flashmap region. Flashmap is a
description of firmware layout supported by coreboot. In order to avoid the
loss of the customized options one has to use the following firmware update
procedure which writes the coreboot code only to the flash:

```
flashrom -p internal -w apuX_v4.YY.0.Z.rom --fmap -i COREBOOT
```

Note you need at least flashrom v1.1 for it to work. Also you will preserve the
coreboot configuration only when updating from v4.14.0.1 version or later on
apu2/3/4/5/6 series. Apu1 does not support the persistent runtime
configuration yet.

If you have a version of apu firmware older than v4.14.0.1 you have to use the
cb-order application to set the runtime configuration options to desired values
before applying the firmware update, otherwise you will lose your current
settings. Then proceed with flashing the firmware as below:

```
flashrom -p internal -w apuX_v4.YY.0.Z.rom 
```
