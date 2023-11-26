TPM support for apu platforms
=============================

## Mainline TPM status

Recently sent patches regarding TPM2.0 support for apu2 boards have been merged:

* https://review.coreboot.org/c/coreboot/+/21983
* https://review.coreboot.org/c/coreboot/+/28000

The Infineon SLB9665 TT 2.0 was not detected properly in coreboot, which caused
wrong TPM startup procedure for this particular chip to be invoked.

### TPM enabling in coreboot for apu2

Currently TPM2.0 can be enabled in mainline menuconfig by selecting option:

Security -> Trusted Platform Module -> Trusted Platform Module -> 2.0

With this setting TPM is initialized properly now and can be used in OS.

### Issues

SeaBIOS does not display the TPM configuration menu despite coreboot initialize
the TPM properly and creates TCPA ACPI table. It looks like SeaBIOS sees it as
TPM 1.2:

```
TCGBIOS: Detected a TPM 1.2.
TCGBIOS: Starting with TPM_Startup(ST_CLEAR)
Return from tpm_simple_cmd(99, 1) = 1e
TCGBIOS: TPM malfunctioning (line 874).
Return from tpm_simple_cmd(73, 0) = 1e
```

Issusng wrong TPM startup leads to TPM malfunctioning output. After
investigating the code which determines the TPM version, one can see, that if
certain field in TPM register is 0, then it is TPM 2.0, TPM 1.2 otherwise:

```
    /* TPM 2 has an interface register */
    u32 ifaceid = readl(TIS_REG(0, TIS_REG_IFACE_ID));

    if ((ifaceid & 0xf) == 0) {
        /* TPM 2 */
        return TPM_VERSION_2;
    }
    return TPM_VERSION_1_2;
```

The first condition fails and code falls down to TPM 1.2.

### Fix

According to Infineon [datasheet](https://www.scribd.com/document/390073324/Infineon-TPM-SLB-9665-DS-v10-15-EN-1-pdf),
the CHIP complies to
[TPM Main Specification, Family "2.0", Level 00, Revision 01.16](https://trustedcomputinggroup.org/resource/tpm-library-specification/).
However I could nto find there any information about hardware registers.

After digging in [TPM PTP specification](https://trustedcomputinggroup.org/wp-content/uploads/TCG_PC_Client_Platform_TPM_Profile_PTP_2.0_r1.03_v22.pdf)
it turns out, that it is not only method to identificate TPM2.0.

Looking at Interface Identifier register (which is used to identify TPM
on SeaBIOS rel-1.11.2) we can see that Interface Type must be 0 for TPM2.0
(page 54).

But...

```
1. A value of 1111b in this field SHALL be interpreted to mean the TPM supports a PC
Client TPM Interface Specification v1.3 compliant FIFO interface.
2. If the TPM supports this specification, the value of this field SHALL NOT be 1111b.
...
4. If this field is set to 0000b:
a. The TPM SHALL correctly report all other capabilities for TPM_INTERFACE_ID_x
fields
b. The TPM SHALL support TPM_INTERFACE_ID_x.InterfaceVersion, which SHALL
be defined for the FIFO interface as 0h.
```

And note 925:

```
TPMs implemented to support PC Client Specific TPM Interface Specification 1.3 or
earlier will return 1111b for InterfaceType. If this field returns 1111b, a TPM may be a
TPM family 2.0 implemented with a FIFO interface compliant with TIS 1.3. If this is
the case, PTP specific features will be implemented as part of the
TPM_INTF_CAPABILITY_x register, not this register.
```

That means there is also Interface Capability register which reports interface
version. See page 100 of PTP specification, bits 28:30:

`011: Interface 1.3 for TPM 2.0 as defined in this specification.`

After correcting the conditions, the TPM should work fine. See work on
[SeaBIOS repository](https://github.com/pcengines/seabios/tree/tpm2_detection)

Utilizing `TPM_INTF_CAPABILITY_x` leads to proper initialization of TPM2.0.

```
TPM ifaceid: ffffffff
TPM ifacecap: 300000ff
TCGBIOS: Detected a TPM 2.
Return from tpm_simple_cmd(144, 0) = 100
TCGBIOS: Return value from sending TPM2_CC_Startup(SU_CLEAR) = 0x00000100
Return from tpm_simple_cmd(143, 1) = 0
TCGBIOS: Return value from sending TPM2_CC_SelfTest = 0x00000000
TCGBIOS: Return value from sending TPM2_CC_GetCapability = 0x00000000
TCGBIOS: LASA = 0xcfe9a000, next entry = 0xcfe9a000
TCGBIOS: SMBIOS at 0x000f6ee0
TCGBIOS: LASA = 0xcfe9a000, next entry = 0xcfe9a048
TCGBIOS: LASA = 0xcfe9a000, next entry = 0xcfe9a0ac
```

One can see that Interface Identifier register value is completely invalid.
SeaBIOS must rely on `TPM_INTF_CAPABILITY_x` register.

NOTE: unfortunately this fix is already present in SeaBIOS mainline repository,
but still on master branch. It is not available on rel-1.11.2 or 1.11-stable

This and few other commits extending TPM support are present:

* d1343e6 tpm: Request access to locality 0
* 4922d6c tpm: when CRB is active, select, lock it, and check addresses
* 8bd306e tpm: revert return values for successful/failed CRB probing
* 408630e tpm: Wait for tpmRegValidSts flag on CRB interface before probing
* 5adc8bd tpm: Handle unimplemented TIS_REG_IFACE_ID in tis_get_tpm_version()
* 96060ad tpm: Wait for interface startup when probing
* 559b3e2 tpm: Refactor duplicated wait code in tis_wait_sts() & crb_wait_reg()
* 9c6e73b tpm: add TPM CRB device support
* a197e20 tpm: use get_tpm_version() callback
* c75d45a tpm: generalize init_timeout()

## Conclusion

To use Infineon SLB9665 TPM2.0 in SeaBIOS, one should use master branch to get
it working.