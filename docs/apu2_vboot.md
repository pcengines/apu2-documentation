Vboot measured boot on apu2
===========================

This document describes a procedure of building a coreboot image for apu2 with
vboot support and measured boot utilizing a TPM module. Procedure will work
only on apu2 versions v4.9.0.6 and newer.

## Building coreboot image

1. Clone the [pce-fw-builder](https://github.com/pcengines/pce-fw-builder)
2. Pull or [build](https://github.com/pcengines/pce-fw-builder#building-docker-image)
  docker container:

  ```
  docker pull pcengines/pce-fw-builder
  ```

3. Build v4.9.0.6 image:

  ```
  ./build.sh release v4.9.0.6 apu2
  ```

4. Invoke distclean:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 distclean
  ```

5. Copy the vboot miniconfig:

  ```
  cp $PWD/release/coreboot/configs/config.pcengines_apu2_vboot $PWD/release/coreboot/.config
  ```

6. Create full config:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 olddefconfig
  ```

7. Build the image again:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 CPUS=$(nproc)
  ```

8. Flash the new image. The firmware image can be found in
  `release/coreboot/build` which is relative to cloned `pce-fw-builder`
  directory.

## Using custom keys

The config file present in repository builds the binary with default vboot
developer keys. If one would like to use own keys, vboot has bash scripts that
simplify the key generation process.

Enter previously cloned coreboot directory and change directory to vboot:

```
cd $PWD/release/coreboot/3rdparty/vboot
```

Compile and install the vboot library (outside docker on the host):

```
make
DESTDIR=/usr sudo make install
```

Then invoke from `$PWD/release/coreboot`:

```
3rdparty/vboot/scripts/keygeneration/create_new_keys.sh --4k --4k-root --output keys
```

This script will produce whole set of new random keys in the `keys` directory.
In order to use them, follow the procedure described previously, but:

6. Create full config:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 olddefconfig
  ```

7. Enter menuconfig:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 menuconfig
  ```

Enter Security -> Verified boot (vboot) -> Vboot keys. Change the directories:

```
$(VBOOT_SOURCE)/tests/devkeys/some_key.vbpubk ----> $(top)/some_key.vbpubk
```

Do the change for all 4 key paths, but do not change the filename (generated
keys have the same names):

```
($(VBOOT_SOURCE)/tests/devkeys/root_key.vbpubk) Root key (public)
($(VBOOT_SOURCE)/tests/devkeys/recovery_key.vbpubk) Recovery key (public)
($(VBOOT_SOURCE)/tests/devkeys/firmware_data_key.vbprivk) Firmware key (private)($(VBOOT_SOURCE)/tests/devkeys/kernel_subkey.vbpubk) Kernel subkey (public)
($(VBOOT_SOURCE)/tests/devkeys/firmware.keyblock) Keyblock to use for the RW regions
```

8. Build the image again:

  ```
  ./build.sh dev-build $PWD/release/coreboot apu2 CPUS=$(nproc)
  ```

9. Flash the new image. The firmware image can be found in
  `release/coreboot/build` which is relative to cloned `pce-fw-builder`
  directory.

## Advantages of vboot

1. Flashmap layout.

Whole flash is divided into sections describe in an FMD (FlashMap Descriptor)
file (located in `src/mainboard/pcengines/apu2` directory). Each section has
strictly precised size. This allows to flash only certain flash regions with
flashrom (requires quite fresh compilation of flashrom).

Flashing a single region, for example RW_SECTION_A:

```
flashrom -p internal -w coreboot.rom --fmap -i RW_SECTION_A
```

> Region names are defined in the FMD file.

2. Verified boot

Each boot component in firmware block A or B (depending which one is correctly
booting) is verified again the keys that signed the blocks and the root key
which public part lies in the recovery region. Only the firmware signed by the
keys that belong to the cryptographical keychain (established during key
generation) is allowed to boot. If the signatures are not matching, another
firmware slot is used (also must pass verification). If everything else fails,
boot from recovery. Recovery partition aka read-only is supposed to be
protected by SPI flash protection mechanism as it make the Root of Trust.

> Note that firmware components signed by different keyset won't work. If You
> change the keys, flash whole firmware.

3. Measured boot

By utlizing TPM capabilities, each boot component is cryptographically measured
i.e. its hash is computed and extended in TPM's PCR (Platform Configuration
Register). The hash is not directly written into PCR, but extended, which means
that TPM takes current PCR value, add the hash value of the component and
rehashes the combined value. The final result is written to PCR. Such approach
has the advantage that the final PCR values after boot process is finished are
fixed. In other words, by measuring the same components, in same order, without
any changes in its content we are able to obtain same PCR values. There is no
other way to obtain the same result if any of the components changed, or if the
measuring order has been altered. Given that, the PCR values can clearly assure
that the firmware has not been tampered.

### How to check it works

In order to verify whether vboot and TPM works, one has to compile the cbmem
utility:

```
cd $PWD/release/coreboot/util/cbmem
make
```

And copy the cbmem executable to the apu2 platform booted with vboot support.
Dump the bootlog to a file:

```
./cbmem -c > bootconsole.log
```

And analyze it. You should see similar messages:

```
Phase 1
FMAP: area GBB found @ 505000 (978944 bytes)
VB2:vb2_check_recovery() Recovery reason from previous boot: 0x0 / 0x0
Phase 2
Phase 3
FMAP: area GBB found @ 505000 (978944 bytes)
FMAP: area VBLOCK_A found @ a0000 (65536 bytes)
FMAP: area VBLOCK_A found @ a0000 (65536 bytes)
VB2:vb2_verify_keyblock() Checking key block signature...
FMAP: area VBLOCK_A found @ a0000 (65536 bytes)
FMAP: area VBLOCK_A found @ a0000 (65536 bytes)
VB2:vb2_verify_fw_preamble() Verifying preamble.
Phase 4
FMAP: area FW_MAIN_A found @ b0000 (2228160 bytes)
VB2:vb2api_init_hash() HW crypto for hash_alg 2 not supported, using SW
tlcl_extend: response is 0
tlcl_extend: response is 0
tlcl_lock_nv_write: response is 0
Slot A is selected
creating vboot_handoff structure
```

And the measurements made during boot process:

```

 PCR-2 51d3adcb927807324651c102e5e07d8085b66bae944f37d4de3d89d6118a595f SHA256 [FMAP: COREBOOT CBFS: bootblock]
 PCR-2 fd582fcb2af6ff4e703b2398df919f94c9c3bbcb675429a1414646d123ab141d SHA256 [FMAP: COREBOOT CBFS: fallback/romstage]
 PCR-0 2547cc736e951fa4919853c43ae890861a3b3264 SHA1 [GBB flags]
 PCR-1 a66c8c2cda246d332d0c2025b6266e1e23c89410051002f46bfad1c9265f43d0 SHA256 [GBB HWID]
 PCR-2 a5e02cf99b58d52493d295dca701fdefe3cfc0afa901a70475c2de20603984e7 SHA256 [FMAP: FW_MAIN_A CBFS: fallback/ramstage]
 PCR-3 269138dedbdc3d6d236212392fb18d29aefce116586c5f058419a214efa866a1 SHA256 [FMAP: FW_MAIN_A CBFS: bootorder]
 PCR-3 269138dedbdc3d6d236212392fb18d29aefce116586c5f058419a214efa866a1 SHA256 [FMAP: FW_MAIN_A CBFS: bootorder]
 PCR-3 269138dedbdc3d6d236212392fb18d29aefce116586c5f058419a214efa866a1 SHA256 [FMAP: FW_MAIN_A CBFS: bootorder]
 PCR-2 6c1d20616d91442b61de89de6bf81f0ee8e929919c9284061e00d004de893994 SHA256 [FMAP: COREBOOT CBFS: spd.bin]
 PCR-3 787ba3c5d060991254426794207f64eefe825f93cdebc00f24e7ca0f2acceae9 SHA256 [PSPDIR]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 ca09ef53266de8a9f95a70b28279fdab4d8d21c48d12f6f20ebba9685adc2168 SHA256 [FMAP: COREBOOT CBFS: AGESA]
 PCR-2 6f51a6e4ea6f26b2a5ae619421d0942515db9977c6136a4a6b3d2759b2616143 SHA256 [FMAP: FW_MAIN_A CBFS: fallback/dsdt.aml]
 PCR-3 269138dedbdc3d6d236212392fb18d29aefce116586c5f058419a214efa866a1 SHA256 [FMAP: FW_MAIN_A CBFS: bootorder]
 PCR-2 a6b195044628cf787c9006c3f8a520a0d3fce1df2566fa1ce0294ecc5daf0441 SHA256 [FMAP: FW_MAIN_A CBFS: fallback/payload]
```

> Some components are listed few times, because access to them is made several
> times. Each time component is accessed from flash, it is measured.

As one can see the logs contain the PCR number that has been extended, the hash
value, used hashing algorithm and then the component name and location that the
measurement is corresponding to.

The final PCR numbers can be checked with `tpm2-tools`. It is pretty hard to
compile them, so there is a prepared docker container that has already the
tools compiled. Refer to [3mdeb/tpm2-tools-docker.](https://github.com/3mdeb/tpm2-tools-docker)

To check PCRs:

```
docker run --privileged --rm -it 3mdeb/tpm2-tools-docker tpm2_pcrlist
```
