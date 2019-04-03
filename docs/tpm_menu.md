SeaBIOS TPM configuration menu
==============================

Since SeaBIOS rel-1.12.0.1 TPM 2.0 module from PC Engines is supported on apu2
platforms (and apu5 where the chip may be soldered down according to BOM
option) in the payload as a configuration menu.

When entering the boot menu on serial console via F10 key, one may notice an
additional option when TPM module is connected to LPC header:

```
SeaBIOS (version rel-1.12.0.1-15-g8993894)

Press F10 key now for boot menu

Select boot device:

1. USB MSC Drive Kingston DataTraveler 3.0 PMAP
2. SD card SB16G 15193MiB
3. AHCI/0: SanDisk SSD i110 16GB ATA-9 Hard-Disk (14566 MiBytes)
4. Payload [setup]
5. Payload [memtest]

t. TPM Configuration
```

`TPM Configuration` option appears when TPM is connected and initialized and
can be entered via `t` key.

## TPM Configuration menu

TPM Configuration menu consists of two options beginning from
[rel-1.12.1.1 SeaBIOS release](https://github.com/pcengines/seabios/releases/tag/rel-1.12.1.1):

```
1. Clear TPM
2. Change active PCR banks

If no change is desired or if this menu was reached by mistake, press ESC to
reboot the machine.
```

### Clear TPM option

Clearing TPM is a reset operation for TPM which does the following:

- resets TPM to the default state
- clears TPM ownership
- clears the TPM stored keys, passwords and certificates

Taking ownership of TPM will be possible in OS after clearing. This option may
be useful when the state of firmware changes and TPM cannot release its secrets
due to different Platform Configuration Registers (PCR) or the OS is unbootable
if the disk is encrypted and configured to auto-decrypt with TPM.

Choosing the clear option with `1` key will cause to print the TPM
configuration menu again without any confirmation of success. The option is
available since SeaBIOS rel-1.12.0.1.

### Change active PCR banks

This option is available since SeaBIOS rel-1.12.1.1. What this option does is
to enable certain PCR banks according to user choice. TPM2.0 chips, comparing
to TPM1.2, have two different PCR banks able to store digests of different
algorithms: SHA1 and SHA256. TPM1.2 modules have only SHA1 banks for PCRs.

To enable or disable the banks choose option 2 in the TPM configuration menu by
typing `2` key:

```
Toggle active PCR banks by pressing number key

  1: SHA1 (enabled)
  2: SHA256 (enabled)

ESC: return to previous menu without changes
A  : activate selection
```

Both banks should be enabled by default. To change the state of one type of
bank types the number referring to the desired bank to toggle the state. For
example to disable SHA1 banks, type `1`:

```
Toggle active PCR banks by pressing number key

  1: SHA1
  2: SHA256 (enabled)

ESC: return to previous menu without changes
A  : activate selection
```

The `(enabled)` string should disappear, but the state has not yet been applied
to the TPM. Now, one has two choices:

- abort the changes by pressing `ESC` key, the SeaBIOS will return to the first TPM
  menu
- or apply the changes by pressing `A` key, the SeaBIOS will have to reboot the
  platform to make changes to TPM.

> uppercase or lowercase does not matter

When pressed `ESC` key and then entered the PCR bank configuration again, one
should see that nothing has changed:

```
Toggle active PCR banks by pressing number key

  1: SHA1 (enabled)
  2: SHA256 (enabled)

ESC: return to previous menu without changes
A  : activate selection
```

But when `A` key was pressed, the platform reboots. After reboot one may verify
if the changes were applied correctly by entering the TPM configuration and then
PCR banks configuration:

```
t. TPM Configuration

1. Clear TPM
2. Change active PCR banks

If no change is desired or if this menu was reached by mistake, press ESC to
reboot the machine.

Toggle active PCR banks by pressing number key

  1: SHA1
  2: SHA256 (enabled)

ESC: return to previous menu without changes
A  : activate selection
```

Note that at least one type of banks has to be enabled when toggling both bank
types to be disabled, the `A  : activate selection` option disappears and does
not allow to apply invalid changes:

```
Toggle active PCR banks by pressing number key

  1: SHA1
  2: SHA256

ESC: return to previous menu without changes
```

In such case, one can only return to the previous menu by pressing `ESC` key.

To reenable the PCR banks follow the same procedure as with disabling, but
apply changes when `(enabled)` string is printed alongside desired type of
banks to be enabled.

#### Verification

In order to verify whether the PCR banks were actually disabled, one may run
`tpm2_pcrlist` command from [tpm2-tools](https://github.com/tpm2-software/tpm2-tools).
The dependencies involved in building tpm2-tools are rather complex so it is
advised to use a dockerized environment for tpm2-tools which 3mdeb has
developed for convenient use of the tool. The source is available on
[3mdeb GitHub](https://github.com/3mdeb/tpm2-tools-docker).

Example execution of tpm2-tools `tpm_pcrlist` command with disabled SHA1 banks:

```
sha1:
sha256:
  0 : 0xD27CC12614B5F4FF85ED109495E320FB1E5495EB28D507E952D51091E7AE2A72
  1 : 0x9CEF4FA7928AD1428CE025EA36BE8C26B4350C6CB50F5D8AAE97AE89E4156EE9
  2 : 0xB38B591AF21E993E34333858293D2AC82FDF6E2D169B1415BF981A4BE0FFD283
  3 : 0xD27CC12614B5F4FF85ED109495E320FB1E5495EB28D507E952D51091E7AE2A72
  4 : 0xEEA509AA8A7554B7B4040C44A580660923246633B3593D0547D4FD52841971E0
  5 : 0xD27CC12614B5F4FF85ED109495E320FB1E5495EB28D507E952D51091E7AE2A72
  6 : 0xD27CC12614B5F4FF85ED109495E320FB1E5495EB28D507E952D51091E7AE2A72
  7 : 0xD27CC12614B5F4FF85ED109495E320FB1E5495EB28D507E952D51091E7AE2A72
  8 : 0x0000000000000000000000000000000000000000000000000000000000000000
  9 : 0x0000000000000000000000000000000000000000000000000000000000000000
  10: 0x0000000000000000000000000000000000000000000000000000000000000000
  11: 0x0000000000000000000000000000000000000000000000000000000000000000
  12: 0x0000000000000000000000000000000000000000000000000000000000000000
  13: 0x0000000000000000000000000000000000000000000000000000000000000000
  14: 0x0000000000000000000000000000000000000000000000000000000000000000
  15: 0x0000000000000000000000000000000000000000000000000000000000000000
  16: 0x0000000000000000000000000000000000000000000000000000000000000000
  17: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  18: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  19: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  20: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  21: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  22: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
  23: 0x0000000000000000000000000000000000000000000000000000000000000000
```

Notice that SHA1 PCRs were not printed due to their unavailability.

> Currently SeaBIOS fills following PCRs: 1, 2 and 4. The rest of the banks is
> filled with default values. The same applies to SHA1 PCRs. This will change
> in the future with the introduction of the measured boot.

The TPM configuration menu is planned to be extended in the future. For other
TPM features and utilisation, one may use [tpm2-tools](https://github.com/tpm2-software/tpm2-tools).
