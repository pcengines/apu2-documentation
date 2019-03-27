ROCA TPM vulnerability verification and status
==============================================

[ROCA vulnerability](https://en.wikipedia.org/wiki/ROCA_vulnerability) was
discovered (October 2017) in a software library, RSALib, provided by Infineon
Technologies. That library is also used in TPM modules. When this vulnerability
is present, a pair of prime numbers used for generating RSA keys is chosen from
a small subset of all available prime numbers. This results in a great loss of
entropy. Details and exact numbers can be found [here](https://crocs.fi.muni.cz/_media/public/papers/nemec_roca_ccs17_preprint.pdf).

## Generating RSA key pairs with TPM

RSA keys can be generated with [tpm2-tools](https://github.com/tpm2-software/tpm2-tools).
SLB 9665 used in TPM module doesn't support 512-bit RSA, so either 1024 or
2048-bit keys must be used. Context is used for key generation, so it must be
generated first:

```
tpm2_createprimary -g 'sha1' -G 'rsa1024:null:aes128cfb' -o tpm.ctx
tpm2_create -C tpm.ctx -Grsa1024 -u key.pub -r key.priv
```

Only the public key is actually required by vulnerability check. It is a good
idea to generate more than one pair, probably using different key sizes -
chances for false positives are extremely low, but not zero.

TPM has limited internal RAM and runs out of memory after 3 operations with
error:

```
ERROR: Tss2_Sys_CreatePrimary(0x902) - tpm:warn(2.0): out of memory for object contexts
```

In this case either rebooting or [flushing open handles manually](https://github.com/tpm2-software/tpm2-tools/issues/303#issuecomment-455309118)
helps. Only `handles-transient` need to be flushed:

```
$ tpm2_getcap -c handles-transient
- 0x80000000
- 0x80000001
- 0x80000002
$ tpm2_flushcontext -c 0x80000000
$ tpm2_flushcontext -c 0x80000001
$ tpm2_flushcontext -c 0x80000002
```

#### Extracting keys hashes

File `key.pub` is a binary file with a TPM-specific header. It is not supported
by the tool for checking for ROCA vulnerability, so the key needs to be
extracted and saved in one of the supported formats, e.g. hex coded number.
This can be done with the following script:

```
#!/bin/bash

rm -f keys.txt

for file in *.pub
do
	dd if=${file} bs=1 skip=24 | hexdump -v -e '/1 "%02x"' >> keys.txt
	echo "" >> keys.txt
done
```

## Testing for ROCA vulnerability

A tool for checking for ROCA TPM vulnerability can be found [here](https://github.com/crocs-muni/roca).
The easiest way is to install it with `pip`:

```
pip install roca-detect
```

All parsed keys can be checked using just one command:

```
roca-detect keys.txt
```

More use cases can be found on the main page of this tool, including tests for
saved SSH hosts keys.

This operation should take no more than a couple of seconds, as it only checks
if the key was generated from insecure prime numbers, without finding the exact
numbers used. It does not generate private keys.

#### Results

This is output from test run on 2 different modules, with both 1024 and 2048-bit
keys generated on each of them:

```
2019-03-25 18:31:17 [11915] WARNING Fingerprint found in modulus keys.txt idx 0
{"type": "mod-hex", "fname": "keys.txt", "idx": 0, "aux": null,
  "n": "0x94b79a35a5d47040df1503670080a7714ae1ee751aeb32071b3db388b3bf80b11f661c4b8819ebd1c716239c9ec5a202b08a2aa3c17ad6cd17075ba49fcd005d8b8fa50c29433db35c1421727472deddd77bced7e6438db4d447008b11cdb018139bfef2e06c4b4a3e672543a7e9333040fd881815e14b1f1338e90180fd0865",
  "marked": true, "time_years": 0.16104529886799998, "price_aws_c4": 70.5861544938444}
(...)
2019-03-25 18:31:17 [11915] INFO ### SUMMARY ####################
2019-03-25 18:31:17 [11915] INFO Records tested: 8
2019-03-25 18:31:17 [11915] INFO .. PEM certs: . . . 0
2019-03-25 18:31:17 [11915] INFO .. DER certs: . . . 0
2019-03-25 18:31:17 [11915] INFO .. RSA key files: . 0
2019-03-25 18:31:17 [11915] INFO .. PGP master keys: 0
2019-03-25 18:31:17 [11915] INFO .. PGP total keys:  0
2019-03-25 18:31:17 [11915] INFO .. SSH keys:  . . . 0
2019-03-25 18:31:17 [11915] INFO .. APK keys:  . . . 0
2019-03-25 18:31:17 [11915] INFO .. JSON keys: . . . 0
2019-03-25 18:31:17 [11915] INFO .. LDIFF certs: . . 0
2019-03-25 18:31:17 [11915] INFO .. JKS certs: . . . 0
2019-03-25 18:31:17 [11915] INFO .. PKCS7: . . . . . 0
2019-03-25 18:31:17 [11915] INFO Fingerprinted keys found: 4
2019-03-25 18:31:17 [11915] INFO WARNING: Potential vulnerability
2019-03-25 18:31:17 [11915] INFO ################################
```

It shows that ROCA vulnerability **is present** on this TPM module model. TPM
firmware update will be required.

Note that ROCA is connected only with RSA, it doesn't affect any other security
functions, as long as they don't use RSALib.

## Updating TPM firmware

Tools for updating Infineon TPM firmware can be easily found, unfortunately,
most of them are either UEFI or Windows applications. A Linux port of them can
be found [here](https://github.com/iavael/infineon-firmware-updater). It
requires openssl-1.0 (both developer files and runtime library), but it can be
updated to 1.1.0 version with [this patch](openssl_1_1_0.patch).

First, check if `TPMFactoryUpd` was built successfully and TPM is detected
properly:

```
$ ./TPMFactoryUpd -info
  **********************************************************************
  *    Infineon Technologies AG   TPMFactoryUpd   Ver 01.01.2459.00    *
  **********************************************************************

       TPM information:
       ----------------
       Firmware valid                    :    Yes
       TPM family                        :    2.0
       TPM firmware version              :    5.61.2785.0
       TPM platformAuth                  :    Empty Buffer
       Remaining updates                 :    64
```

Remember the current firmware version number, it will be needed later. Also note
what is the value of `TPM platformAuth` - it must be `Empty Buffer` in order to
perform an update. To do this, build and flash coreboot with TPM disabled in
config menu, or use older version of BIOS - none of the v4.8.0.* versions have
TPM support enabled. SeaBIOS doesn't need any modifications, it will not
initialize TPM unless coreboot does.

TPM firmwares are available with some of the UEFI and Windows images, like
[these](ftp://ftp.supermicro.com/driver/TPM/9665FW%20update%20package_1.5.zip).
Only `9665FW update package_1.5/Firmware/TPM20_<old_version>_to_TPM20_5.63.3144.0.BIN`
file is required. Extract this file to the same directory as the `TPMFactoryUpd`
and run:

```
$ ./TPMFactoryUpd -update tpm20-emptyplatformauth -firmware TPM20_<old_version>_to_TPM20_5.63.3144.0.BIN
  **********************************************************************
  *    Infineon Technologies AG   TPMFactoryUpd   Ver 01.01.2459.00    *
  **********************************************************************

       TPM update information:
       -----------------------
       Firmware valid                    :    Yes
       TPM family                        :    2.0
       TPM firmware version              :    5.61.2785.0
       TPM platformAuth                  :    Empty Buffer
       Remaining updates                 :    64
       New firmware valid for TPM        :    Yes
       TPM family after update           :    2.0
       TPM firmware version after update :    5.63.3144.0

       Preparation steps:
       TPM2.0 policy session created to authorize the update.

    DO NOT TURN OFF OR SHUT DOWN THE SYSTEM DURING THE UPDATE PROCESS!

       Updating the TPM firmware ...
       Completion: 100 %
       TPM Firmware Update completed successfully.
```

This can take 3-5 minutes, depending on the firmware update size. After it
completes, TPM is not useful until the next reboot:

```
$ ./TPMFactoryUpd -info
  **********************************************************************
  *    Infineon Technologies AG   TPMFactoryUpd   Ver 01.01.2459.00    *
  **********************************************************************

       TPM information:
       ----------------
       Firmware valid                    :    Yes
       TPM family                        :    2.0
       TPM firmware version              :    5.63.3144.0
       TPM platformAuth                  :    N/A - System restart required
       Remaining updates                 :    N/A - System restart required
```

Reboot platform immediately. Using TPM functions in this state isn't safe.
After successful reboot and flashing original coreboot firmware the result
should be:

```
$ ./TPMFactoryUpd -info
  **********************************************************************
  *    Infineon Technologies AG   TPMFactoryUpd   Ver 01.01.2459.00    *
  **********************************************************************

       TPM information:
       ----------------
       Firmware valid                    :    Yes
       TPM family                        :    2.0
       TPM firmware version              :    5.63.3144.0
       TPM platformAuth                  :    Not Empty Buffer
       Remaining updates                 :    63
```

#### Updating TPM firmware - automatic version detection

Assuming that a whole `Firmware` directory was extracted to directory containing
`TPMFactoryUpd` from the [update package](ftp://ftp.supermicro.com/driver/TPM/9665FW%20update%20package_1.5.zip),
one can use single command to do the update. Appropriate file is chosen
automatically, depending on the old version. The command is:

```
$ ./TPMFactoryUpd -update config-file -config Firmware/TPM20_latest.cfg
  **********************************************************************
  *    Infineon Technologies AG   TPMFactoryUpd   Ver 01.01.2459.00    *
  **********************************************************************

       TPM update information:
       -----------------------
       Firmware valid                    :    Yes
       TPM family                        :    2.0
       TPM firmware version              :    5.51.2098.0
       TPM platformAuth                  :    Empty Buffer
       Remaining updates                 :    64
       New firmware valid for TPM        :    Yes
       TPM family after update           :    2.0
       TPM firmware version after update :    5.63.3144.0

       Selected firmware image:
       TPM20_5.51.2098.0_to_TPM20_5.63.3144.0.BIN

       Preparation steps:
       TPM2.0 policy session created to authorize the update.

    DO NOT TURN OFF OR SHUT DOWN THE SYSTEM DURING THE UPDATE PROCESS!

       Updating the TPM firmware ...
       Completion: 100 %
       TPM Firmware Update completed successfully.
```

Remember to use BIOS with TPM disabled, and re-flash newer BIOS firmware
afterwards.

#### Results from new version of TPM firmware

Repeating all steps from generating TPM context to using `roca-detect` shows
that the vulnerability is **no longer present**:

```
2019-03-26 18:40:42 [4325] INFO ### SUMMARY ####################
2019-03-26 18:40:42 [4325] INFO Records tested: 8
2019-03-26 18:40:42 [4325] INFO .. PEM certs: . . . 0
2019-03-26 18:40:42 [4325] INFO .. DER certs: . . . 0
2019-03-26 18:40:42 [4325] INFO .. RSA key files: . 0
2019-03-26 18:40:42 [4325] INFO .. PGP master keys: 0
2019-03-26 18:40:42 [4325] INFO .. PGP total keys:  0
2019-03-26 18:40:42 [4325] INFO .. SSH keys:  . . . 0
2019-03-26 18:40:42 [4325] INFO .. APK keys:  . . . 0
2019-03-26 18:40:42 [4325] INFO .. JSON keys: . . . 0
2019-03-26 18:40:42 [4325] INFO .. LDIFF certs: . . 0
2019-03-26 18:40:42 [4325] INFO .. JKS certs: . . . 0
2019-03-26 18:40:42 [4325] INFO .. PKCS7: . . . . . 0
2019-03-26 18:40:42 [4325] INFO No fingerprinted keys found (OK)
2019-03-26 18:40:42 [4325] INFO ################################
```
