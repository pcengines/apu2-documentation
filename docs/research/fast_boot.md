PC Engines fast boot
====================

## Long boot time

PC Engines apu2 platforms are booting coreboot in approximately 2.6s while
the memory training takes over 2s. Dump of cbmem timestamps on v4.9.0.2
firmware on apu:

```
   0:1st timestamp                                     18,886
   1:start of romstage                                 18,958 (71)
   2:before ram initialization                         46,334 (27,376)
   3:after ram initialization                          2,225,788 (2,179,453)
   4:end of romstage                                   2,298,974 (73,185)
   8:starting to load ramstage                         2,299,924 (949)
  15:starting LZMA decompress (ignore for x86)         2,300,264 (340)
  16:finished LZMA decompress (ignore for x86)         2,341,499 (41,234)
   9:finished loading ramstage                         2,343,593 (2,094)
  10:start of ramstage                                 2,343,929 (335)
  30:device enumeration                                2,343,937 (8)
  40:device configuration                              2,347,291 (3,354)
  50:device enable                                     2,349,098 (1,806)
  60:device initialization                             2,381,455 (32,356)
  70:device setup done                                 2,452,309 (70,853)
  75:cbmem post                                        2,472,769 (20,460)
  80:write tables                                      2,472,773 (3)
  85:finalize chips                                    2,475,425 (2,652)
  90:load payload                                      2,475,637 (211)
  15:starting LZMA decompress (ignore for x86)         2,475,906 (269)
  16:finished LZMA decompress (ignore for x86)         2,514,778 (38,871)
  99:selfboot jump                                     2,514,808 (30)
```

## Memory Context Restore

AGESA has an option called Memory Context Restore which restores the
configuration of the memory controller from non-volatile storage. The feature
should dramatically reduce of memory training time after first boot.

```
  IN BOOLEAN MemRestoreCtl;        ///< Memory context restore control
                                   ///<   FALSE = perform memory init as normal (AMD default)
                                   ///<   TRUE = restore memory context and skip training. This requires
                                   ///<          MemContext is valid before AmdInitPost
                                   ///<
  IN BOOLEAN SaveMemContextCtl;    ///< Control switch to save memory context at the end of MemAuto
                                   ///<   TRUE = AGESA will setup MemContext block before exit AmdInitPost
                                   ///<   FALSE = AGESA will not setup MemContext block. Platform is
                                   ///<           expected to call S3Save later in POST if it wants to
                                   ///<           use memory context restore feature.
                                   ///<
  IN OUT AMD_S3_PARAMS MemContext; ///< Memory context block describes the data that platform needs to
                                   ///< save and restore for memory context restore feature to work.
                                   ///< It uses the subset of S3Save block to save/restore. Hence platform
                                   ///< may save only S3 block and uses it for both S3 resume and
                                   ///< memory context restore.
                                   ///<  - If MemRestoreCtl is TRUE, platform needs to pass in MemContext
                                   ///<    before AmdInitPost.
                                   ///<  - If SaveMemContextCtl is TRUE, platform needs to save MemContext
                                   ///<    right after AmdInitPost.
```

## Implementation and testing

Implementation of memory context restore feature contained:

- passsing correct values to `MemRestoreCtl` and `SaveMemContextCtl` in
  following manner:
    - set `MemRestoreCtl` to TRUE
    - set `SaveMemContextCtl` to TRUE if memory context present and valid;
          FALSE otherwise
- obtain memory context from AGESA in `MemContext` structure and save it in SPI
  flash

### Results

At first boot platform behaved correctly, the booting contained normal memory
training. However, after a reboot or second boot, the platform began to reset
unexpectedly during iPXE booting or normal kernel loading from storage. Such
behaviour could point to incorrect memory initialization.

Further debugging of the memory context restoring revealed that the memory
context returned by AGESA is inconsistent across boots. The test conditions
were as follows:

- set `MemRestoreCtl` to TRUE
- do not save `MemContext` in SPi flash in order to force memory training after
  each boot

Dumps of the memory context showed that the content is different each time
platform boots. The differences always occurred on fixed offsets in the
structure:

- 0x220 (single byte changes)
- 0x300 (multiple byte changes in 80-byte long block)
- 0x390 (multiple byte changes in 80-byte long block)

Example diff of offset 0x300 across two random boots:

```
00 52 4a 00 00 00 00 00 00 5c 00 5d 00 60 00 62  .RJ......\.].`.b
00 65 00 00 00 70 00 6e 00 77 00 78 00 1b 1c 25  .e...p.n.w.x...%
24 32 30 37 35 2b 00 00 00 14 14 14 14 14 14 14  $2075+..........
14 0b 00 0a 00 13 00 11 00 19 00 00 00 20 00 20  ............. . 
00 25 00 23 00 38 03 38 03 00 00 00 00 03 00 00  .%.#.8.8........
=================
00 52 4a 00 00 00 00 00 00 5c 00 5d 00 60 00 62  .RJ......\.].`.b
00 64 00 00 00 70 00 6e 00 76 00 78 00 1a 1c 24  .d...p.n.v.x...$
24 32 30 37 35 2c 00 00 00 14 14 14 14 14 14 14  $2075,..........
14 0a 00 0a 00 12 00 11 00 1a 00 00 00 20 00 20  ............. . 
00 25 00 23 00 38 03 38 03 00 00 00 00 03 00 00  .%.#.8.8........
```

The conclusion is that restoring the memory context from non-volatile storage
is not reliable. Platform skipped training and initialized memory controller
with wrong values taken from context. Without correctly initialized memory the
platform could not load any kernel, thus kept resetting unexpectedly.

### AMD and community statement

The fast boot topic has been also touched by coreboot community:

https://review.coreboot.org/c/coreboot/+/22727

The most interesting are the comments:

```
Unfortunately, according to AMD, we can only use the saved training results for S3 resume, and not as part of a fastboot path...
```

```
AMD has taken a pretty strong position that an Intel-like "fast boot" is not practical to develop.
```

Given that it is impossible to use available AGESA binary to implement fast
boot feature.
