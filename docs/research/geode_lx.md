ALIX and AMD Geode LX
=====================


This paper contains research about Geode LX CAR and whole effort to implement
`EARLY_CBMEM_INIT` in coreboot for PC Engines ALIX platforms.

[TOC]

List of abbreviations
---------------------

* `SDM` - Software Developer Manual
* `MTRR` - Memory Type Range Register
* `MSR` - Model Specific Register
* `CAR` - Cache-as-RAM
* `UC` - Strong Uncacheable
* `UC-` - Uncacheable
* `WC` - Write Combining
* `WT` - Write Through
* `WB` - Write Back
* `WP` - Write Protected


# Memory initialisation

Current ALIX platforms support in coreboot (state at the day of writing this
document) lets user build a firmware capable to boot the platform without
issues. However... With coreboot 4.7 version, new standards has been introduced
which every platform must meet to be supported (to stay in the main branch). One
of these standards (requirements) is `EARLY_CBMEM_INIT` to be used by platform.
`EARLY_CBMEM_INIT` allows to save log to cbmem early in romstage, but that's not
all about it. To get all benefits of `EARLY_CBMEM_INIT`, the main memory need to
be initialised and addressable in romstage. Unfortunately ALIX platforms
initialize memory in ramstage, which breaks the model proposed by coreboot
project.

In order to achieve the goal (move platform to `EARLY_CBMEM_INIT`), deeper
understading of caching, memory initialisation and CAR is needed. Below
sections describes steps needed to reach the goal.

## Memory types and caching policies

Intel SDM is a good source of knowledge about caching and memory types.
Detialed description is available in Intel SDM vol 3A Section 11.3.

In brief Intel describes 6 memory types which are used in Intel's hardware:

* `UC` - System memory locations are not cached. All reads and writes appear on
  the system bus and are executed in program order without reordering.
* `UC-` - Has same characteristics as the strong uncacheable (UC) memory type,
  except that this memory type can be overridden by programming the MTRRs for
  the WC memory type
* `WC` - System memory locations are not cached (as with uncacheable memory) and
  coherency is not enforced by the processor’s bus coherency protocol.
  Speculative reads are allowed. Writes may be delayed and combined in the write
  combining buffer (WC buffer) to reduce memory accesses. If the WC buffer is
  partially filled, the writes may be delayed until the next occurrence of a
  serializing event
* `WT` - Writes and reads to and from system memory are cached. Reads come from
  cache lines on cache hits; read misses cause cache fills. Speculative reads
  are allowed. All writes are written to a cache line (when possible) and
  through to system memory. When writing through to memory, invalid cache lines
  are never filled, and valid cache lines are either filled or invalidated.
  Write combining is allowed.
* `WB` - Writes and reads to and from system memory are cached. Reads come from
  cache lines on cache hits; read misses cause cache fills. Speculative reads
  are allowed. Write misses cause cache line fills, and writes are performed
  entirely in the cache, when possible. Write combining is allowed. The
  write-back memory type reduces bus traffic by eliminating many unnecessary
  writes to system memory. Writes to a cache line are not immediately forwarded
  to system memory; instead, they are accumulated in the cache. The modified
  cache lines are written to system memory later, when a write-back operation
  is performed.
* `WP` - Reads come from cache lines when possible, and read misses cause cache
  fills. Writes are propagated to the system bus and cause corresponding cache
  lines on all processors on the bus to be invalidated. Speculative reads are
  allowed.

Section 11.2 describes the terms `cache line fill`, `cache hit` and `write hit`.

## MTRRS

MTRRs are registers responsible for setting memory type for given address ranges
of physical memory. They are divided into two groups:

* fixed MTRRs
* variable MTRRs

MTRR availability if identified by bit 12 in EDX register after issuing CPUID
instruction. Additional information about MTRRs are stored in `IA32_MTRRCAP` MSR
which is read-only. It defines variable MTRRs count, fixed MTRRs count etc.

All MTRRs and `IA32_MTRRCAP` are described in Section 11.11 in Intel SDM vol 3A
and subsequent subsections.

### Fixed MTRRs

Fixed MTRR allows to set memory type for region handled by corresponding MTRR.
There are 3 types of fixed MTRRs based on address range covered:

* Register `IA32_MTRR_FIX64K_00000` — Maps the 512-KByte address range from 0H
  to 7FFFFH. This range is divided into eight 64-KByte sub-ranges
* Registers `IA32_MTRR_FIX16K_80000` and `IA32_MTRR_FIX16K_A0000` — Maps the two
  128-KByte address ranges from 80000H to BFFFFH. This range is divided into
  sixteen 16-KByte sub-ranges, 8 ranges per register.
* Registers `IA32_MTRR_FIX4K_C0000` through `IA32_MTRR_FIX4K_F8000` — Maps eight
  32-KByte address ranges from C0000H to FFFFFH. This range is divided into
  sixty-four 4-KByte sub-ranges, 8 ranges per register.

These registers can set memory type only for a `fixed` address range.

### Variable MTRRs

`IA32_MTRRCAP` MSR contains number of variable ranges supported by CPU (this
number is also an upper limit of variable MTRRs). These MTRRs allow to define
not only memory type, but also the address range it will be applied to.

The range is defined by programming BASE and MASK registers.

> NOTE: all MTRRS must be consistent across all CPUs in multi-processor systems.

### Geode LX MTRRs

Geode LX registers does not have typical MTRRs as described in Intel SDM.
Do not be surprised, it is quite old processor and created by AMD of course.
However there is a set of MSRs which serve the same purpose as MTRRs.

The equivalents of MTRRs are described below.

