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
helps. Only `handles-transient` needs to be flushed.

## Extracting keys hashes

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

## Results

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
