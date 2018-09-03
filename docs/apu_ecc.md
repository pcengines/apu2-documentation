Issues with ECC enabling
========================

According to previous work on this issue ECC error injection fails due to
a range of memory that is used by APUs integrated graphics being excluded from
ECC support. This feature is controlled by a couple of registers, one of them is
D18F5x240, which has bit EccExclEn. This bit is set by AGESA as 1 soon after
memory training.

>#TODO: test if this is the only problem

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
it along the way before memory initialization.

>#TODO: to be tested

Somewhere between memory training and setting UMA I receive
`WARNING Event: 04012200 Data: 0, 0, 0, 0`.
From specification:
> MEM_WARNING_BANK_INTERLEAVING_NOT_ENABLED

I don't know if this is connected in any way to problems with ECC.
