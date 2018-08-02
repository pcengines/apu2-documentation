Doubled sign of life
====================

Problem description
-------------------

Sometimes sign of life happens twice. It is caused by reset of platform during
warmboot (doing `rte_ctrl -pon` when the platform is in S5). Problem does
not occur when doing coldboot or reboot.

Initial ideas
-------------

AGESA specification 44065 Rev. 3.03 (not publicly available) on page 41 and
followings in the operational overview says:

> E — Main boot path. Proceed with full hardware initialization.
> Warm reset may be needed to instantiate new values into some registers.

 Next page, about AGESA software call entry points' duties:

```
AmdInitReset
    initialize heap ctl
    Primary ncHt link initialization
    SB initialization @ reset
    NB after HT

AmdInitEarly
    register load
    full HT initialization
    uCode patch load
    AP launch
    PwrMgmt Init
    NB post initialization
    Detect need for warm reset
```

It looks like moving SOL after call to `AmdInitEarly()` would fix the issue,
but then it gets printed after a relatively long period - user might think
that platform isn't booting, also it almost immediately disappears.

