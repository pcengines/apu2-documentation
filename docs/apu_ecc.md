Issues with ECC enabling
========================

According to previous work on this issue ECC error injection fails due to
a range of memory that is used by APUs integrated graphics being excluded from
ECC support. This feature is controlled by a couple of registers, one of them is
D18F5x240, which has bit EccExclEn. This bit is set by AGESA as 1 soon after
memory training.

Using version of AGESA that doesn't set mentioned bit results in working
ECC error injection in MemTest86 V7.4 Pro on apu2 and apu4:

```
2018-09-25 16:59:03 - MtSupportRunAllTests - Injecting ECC error
2018-09-25 16:59:03 - inject_amd64 - new nb_arr_add = 80000000
2018-09-25 16:59:03 - inject_amd64 - new dram_ecc = 0012000F
2018-09-25 16:59:03 - MCA NB Status High=00000000
2018-09-25 16:59:03 - inject_amd64 - new nb_arr_add = 80000002
2018-09-25 16:59:03 - inject_amd64 - new dram_ecc = 0012000F
2018-09-25 16:59:03 - MCA NB Status High=00000000
2018-09-25 16:59:03 - inject_amd64 - new nb_arr_add = 80000004
2018-09-25 16:59:03 - inject_amd64 - new dram_ecc = 0012000F
2018-09-25 16:59:03 - MCA NB Status High=00000000
2018-09-25 16:59:03 - MtSupportRunAllTests - Setting random seed to 0x50415353
2018-09-25 16:59:03 - MtSupportRunAllTests - Start time: 453 ms
2018-09-25 16:59:03 - ReadMemoryRanges - Available Pages = 1035071
2018-09-25 16:59:03 - MtSupportRunAllTests - Enabling memory cache for test
2018-09-25 16:59:03 - MtSupportRunAllTests - Enabling memory cache complete
2018-09-25 16:59:03 - Start memory range test (0x0 - 0x12F000000)
2018-09-25 16:59:03 - Pre-allocating memory ranges >=16MB first...
2018-09-25 16:59:04 - All memory ranges successfully locked
2018-09-25 16:59:04 - MCA NB Status=846FC000F2080813 
2018-09-25 16:59:04 - MCA NB Address=00000000CFE528E0
2018-09-25 16:59:04 - [MEM ERROR - ECC] Test: 3, Address: CFE528E0, ECC Corrected: yes, Syndrome: F2DF, Channel/Slot: N/A
2018-09-25 17:00:08 - MCA NB Status=846FC000F2080813 
2018-09-25 17:00:08 - MCA NB Address=00000000CE3F46C0
2018-09-25 17:00:08 - [MEM ERROR - ECC] Test: 3, Address: CE3F46C0, ECC Corrected: yes, Syndrome: F2DF, Channel/Slot: N/A
```

Configuration file used:
```
TSTLIST=3,5,13
NUMPASS=2

DISABLEMP=1
ECCPOLL=1
ECCINJECT=1

AUTOMODE=1
SKIPSPLASH=1
CONSOLEMODE=0
```
List of tests and number of passed were stripped down to speed up research.
`DISABLEMP` is set because of buggy multiprocessor support in UEFI. `ECCPOLL`
enables checking for detected ECC errors after each test and `ECCINJECT` enables
ECC error injection on start of each test. The rest of options enables automode
with report generation.

On apu3 with 2GB RAM ECC isn't detected at all because of SPD which doesn't
report this feature.

Potential workarounds
---------------------

[AGESA specification](https://support.amd.com/TechDocs/44065_Arch2008.pdf) mentions
a build time option:
>BLDCFG_UMA_ALLOCATION_MODE
>	Supply the UMA memory allocation mode build time customization, if any.
>	The default mode is Auto.
>	* UMA_NONE — no UMA memory will be allocated.
>	* UMA_SPECIFIED — up to the requested UMA memory will be allocated.
>	* UMA_AUTO — allocate the optimum UMA memory size for the platform.
>	
>	For APUs with integrated graphics, this will provide the optimum
>	UMA allocation for the platform and for other platforms will be the
>	same as NONE

There is also a runtime option `UmaMode` in `MemConfig`, which is parameter for
`AmdInitPost`, but it isn't clear if AGESA uses data received from host or changes
it along the way before memory initialization. However, initial value of `UmaMode`
already is `UMA_NONE`, and neither changing it before calling `AmdInitPost` nor
in any callout functions doesn't change the outcome.

Clearing bit EccExclEn in register D18F5x240 from coreboot after it gets set by
AGESA seems to work as well. Description of this register in
[BKDG, 52740 Rev 3.06](https://www.amd.com/system/files/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf)
informs that
>BIOS must quiesce all other forms of DRAM traffic when configuring this range.
>See MSRC001_001F[DisDramScrub].

Additional findings
-------------------

Somewhere between memory training and setting UMA I receive
`WARNING Event: 04012200 Data: 0, 0, 0, 0`.
From specification:
> MEM_WARNING_BANK_INTERLEAVING_NOT_ENABLED

I don't know if this is connected in any way to problems with ECC.

Every corrected ECC error has the same syndrome - F2DF. It is caused by MemTest86
setting D18F3xBC_x8 (DRAM ECC) to `0012000F`. More info about meaning of these is
available in [BKDG](https://www.amd.com/system/files/TechDocs/52740_16h_Models_30h-3Fh_BKDG.pdf)
on pages 172-174 (ECC syndromes) and 456 (DRAM ECC register). Another register
that is set by MemTest86 is D18F3xB8 (NB Array Address) as `8000000x`, where `x`
is 0, 2 and 4.

On apu3 (4GB version) and apu5 register D18F3xB8 have some bits set on fields
marked as reserved in BKDG. After clearing these bits before starting MemTest86
ECC injection started to work as expected on all platforms with ECC-capable memory.
