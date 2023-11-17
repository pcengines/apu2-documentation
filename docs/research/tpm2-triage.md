Report of TPM2 support
======================

## Conclusion

Works with `tpm_tis` module bypassing the BIOS in TPM setup. Verified on Voyage
Linux 0.10.0 and Debian jessie.

## Actual steps taken

HW used: APU2 with TPM LPC addon

1. Install 4.13.0-rc6 kernel - [config](https://github.com/pcengines/apu2-documentation/blob/master/docs/research/4_13_rc6_tpm_config)
2. Enable tpm2 module:

    ```
    modprobe tpm_tis force=1 interrupts=0
    ```

    > `/dev/tpm0` should appear

3. Install packages:
    ```
    apt -y install \
      autoconf-archive \
      libcmocka0 \
      libcmocka-dev \
      build-essential \
      git \
      pkg-config \
      gcc \
      g++ \
      m4 \
      libtool \
      automake \
      autoconf \
      libssl-dev \
      libssl1.0.0 \
      libcurl4-openssl-dev
    ```

4. `git clone https://github.com/01org/tpm2-tss.git`

5. Build **tpm2-tss** lib (i.e. **sapi**)
    ```
    ./bootstrap
    ./configure
    make -j$(nproc)
    make install
    ldconfig
    ```
6. `git clone https://github.com/01org/tpm2-tools`

7. Build **tpm2-tools**
    ```
    ./bootstrap
    ./configure
    make -j$(nproc)
    make install
    ```

8. Check the device:
    ```
    $ tpm2_dump_capability -T device -c properties-fixed
    TPM_PT_FAMILY_INDICATOR:
      as UINT32:                0x08322e3000
      as string:                "2.0"
    TPM_PT_LEVEL:               0
    TPM_PT_REVISION:            1.16
    TPM_PT_DAY_OF_YEAR:         0x000000d1
    TPM_PT_YEAR:                0x000007df
    TPM_PT_MANUFACTURER:        0x49465800
    TPM_PT_VENDOR_STRING_1:
      as UINT32:                0x534c4239
      as string:                "SLB9"
    TPM_PT_VENDOR_STRING_2:
      as UINT32:                0x36363500
      as string:                "665"
    TPM_PT_VENDOR_STRING_3:
      as UINT32:                0x00000000
      as string:                ""
    TPM_PT_VENDOR_STRING_4:
      as UINT32:                0x00000000
      as string:                ""
    TPM_PT_VENDOR_TPM_TYPE:     0x00000000
    TPM_PT_FIRMWARE_VERSION_1:  0x00050033
    TPM_PT_FIRMWARE_VERSION_2:  0x00083200
    TPM_PT_INPUT_BUFFER:        0x00000400
    TPM_PT_HR_TRANSIENT_MIN:    0x00000003
    TPM_PT_HR_PERSISTENT_MIN:   0x00000007
    TPM_PT_HR_LOADED_MIN:       0x00000003
    TPM_PT_ACTIVE_SESSIONS_MAX: 0x00000040
    TPM_PT_PCR_COUNT:           0x00000018
    TPM_PT_PCR_SELECT_MIN:      0x00000003
    TPM_PT_CONTEXT_GAP_MAX:     0x0000ffff
    TPM_PT_NV_COUNTERS_MAX:     0x00000008
    TPM_PT_NV_INDEX_MAX:        0x00000680
    TPM_PT_MEMORY:              0x00000006
    TPM_PT_CLOCK_UPDATE:        0x00080000
    TPM_PT_CONTEXT_HASH:        0x0000000b
    TPM_PT_CONTEXT_SYM:         0x00000006
    TPM_PT_CONTEXT_SYM_SIZE:    0x00000080
    TPM_PT_ORDERLY_COUNT:       0x000000ff
    TPM_PT_MAX_COMMAND_SIZE:    0x00000500
    TPM_PT_MAX_RESPONSE_SIZE:   0x00000500
    TPM_PT_MAX_DIGEST:          0x00000020
    TPM_PT_MAX_OBJECT_CONTEXT:  0x00000396
    TPM_PT_MAX_SESSION_CONTEXT: 0x000000eb
    TPM_PT_PS_FAMILY_INDICATOR: 0x00000001
    TPM_PT_PS_LEVEL:            0x00000000
    TPM_PT_PS_REVISION:         0x00000100
    TPM_PT_PS_DAY_OF_YEAR:      0x00000000
    TPM_PT_PS_YEAR:             0x00000000
    TPM_PT_SPLIT_MAX:           0x00000080
    TPM_PT_TOTAL_COMMANDS:      0x0000005a
    TPM_PT_LIBRARY_COMMANDS:    0x00000058
    TPM_PT_VENDOR_COMMANDS:     0x00000002
    TPM_PT_NV_BUFFER_MAX:       0x00000300
    $ tpm2_getrandom -T device 10
    0x84 0xCF 0xA4 0xF8 0xEC 0x43 0x11 0xA4 0x7D 0xE8
    ```
