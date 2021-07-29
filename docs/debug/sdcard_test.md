
#### GOOD-inserted

   * Card is inserted into slot before power on.
   * Check if card appears as a bootitem in bootmenu. (IT IS)

#### GOOD-not-inserted

   * Card is not inserted into slot
   * Enter boot menu and insert card
   * Go to setup, exit without save (`x`).
   * Go to boot menu again and check if card appears as a bootitem (IT IS)

#### BAD-inserted

   * Card is inserted into slot before power on.
   * Check if card appears as a bootitem in bootmenu. (IT IS NOT)

#### BAD-not-inserted

   * Card is not inserted into slot.
   * Enter boot menu and insert card.
   * Go to setup, exit without save (`x`).
   * Go to boot menu again and check if card appears as a bootitem. (IT IS)

### Diff analyze


1. [GOOD-not-inserted.cap](https://github.com/pcengines/apu2-documentation/blob/master/docs/debug/logs/GOOD-not-inserted.cap)
      vs [BAD-not-inserted.cap](https://github.com/pcengines/apu2-documentation/blob/master/docs/debug/logs/BAD-not-inserted.cap)

      No differences other than timing differences such as:

      ```
      BS: BS_PAYLOAD_LOAD times (us): entry 0 run 48848 exit 0

      vs

      BS: BS_PAYLOAD_LOAD times (us): entry 0 run 48978 exit 0
      ```

2. `GOOD-inserted.cap` vs `BAD-inserted.cap`

      `77f59000` is card initialization thread

      ```
      |77f5d000| phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f5eb80)
      ```

      GOOD:

      ```
      phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f61110)
      /77f59000\ Start thread
      |77f59000| Searching bootorder for: /pci@i0cf8/*@14,7
      |77f59000| sdhci@0xfeb25500 ver=1001 cap=21fe32b2 70
      |77f59000| phys_alloc zone=0x77f6df18 size=44 align=10 ret=f0920 (detail=0x77f5eef0)
      |77f59000| sdcard_set_frequency 50 400 4000
      |77f59000| sdcard_set_frequency 50 200000 0
      |77f59000| host_control contains 0x00000f04
      |77f59000| phys_alloc zone=0x77f6df10 size=80 align=10 ret=77f5ef30 (detail=0x77f611e0)
      |77f59000| Found sdcard at 0xfeb25500: SD card SS08G 7580MiB
      |77f59000| phys_alloc zone=0x77f6df10 size=24 align=10 ret=77f61140 (detail=0x77f5ee90)
      |77f59000| Registering bootable: SD card SS08G 7580MiB (type:2 prio:5 data:f0920)
      \77f59000/ End thread
      phys_free 77f59000 (detail=0x77f61110)

      |77f5d000| phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f5eca0)
      /77f59000\ Start thread
      |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
      |77f59000| phys_free 77f5ed00 (detail=0x77f5ecd0)
      \77f59000/ End thread
      phys_free 77f59000 (detail=0x77f5eca0)
      ```

      BAD:

      ```
      phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f61110)
      /77f59000\ Start thread
      |77f59000| Searching bootorder for: /pci@i0cf8/*@14,7
      |77f59000| sdhci@0xfeb25500 ver=1001 cap=21fe32b2 70
      |77f59000| phys_alloc zone=0x77f6df18 size=44 align=10 ret=f0920 (detail=0x77f5ecc0)
      |77f59000| sdcard_set_frequency 50 400 4000
      |77f59000| sdcard_pio command stop (code=1)
      |77f59000| sdcard_pio command stop (code=1)
      |77f59000| sdcard_pio command stop (code=1)
      |77f59000| phys_free f0920 (detail=0x77f5ecc0)
      \77f59000/ End thread
      phys_free 77f59000 (detail=0x77f61110)

      |77f5d000| phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f5eb80)
      /77f59000\ Start thread
      |77f59000| ehci_send_pipe qh=0x77f5ed80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ed80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ed80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ed80 dir=128 data=0x77f59f64 size=4
      |77f59000| ehci_send_pipe qh=0x77f5ed80 dir=128 data=0x77f59f64 size=4
      |77f59000| phys_free 77f5ebe0 (detail=0x77f5ebb0)
      \77f59000/ End thread
      phys_free 77f59000 (detail=0x77f5eb80)
      ```

3. BAD-not-inserted

   proper initializaton of `bad` card:

   ```
   phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f61110)
   /77f59000\ Start thread
   |77f59000| Searching bootorder for: /pci@i0cf8/*@14,7
   |77f59000| sdhci@0xfeb25500 ver=1001 cap=21fe32b2 70
   |77f59000| phys_alloc zone=0x77f6df18 size=44 align=10 ret=f0920 (detail=0x77f5eef0)
   |77f59000| sdcard_set_frequency 50 400 4000
   |77f59000| sdcard_set_frequency 50 200000 0
   |77f59000| host_control contains 0x00000f04
   |77f59000| phys_alloc zone=0x77f6df10 size=80 align=10 ret=77f5ef30 (detail=0x77f611e0)
   |77f59000| Found sdcard at 0xfeb25500: SD card SS08G 7580MiB
   |77f59000| phys_alloc zone=0x77f6df10 size=24 align=10 ret=77f61140 (detail=0x77f5ee90)
   |77f59000| Registering bootable: SD card SS08G 7580MiB (type:2 prio:5 data:f0920)
   \77f59000/ End thread
   phys_free 77f59000 (detail=0x77f61110)

   |77f5d000| phys_alloc zone=0x77f6df10 size=4096 align=1000 ret=77f59000 (detail=0x77f5eca0)
   /77f59000\ Start thread
   |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
   |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
   |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
   |77f59000| ehci_send_pipe qh=0x77f5ef80 dir=128 data=0x77f59f64 size=4
   |77f59000| phys_free 77f5ed00 (detail=0x77f5ecd0)
   \77f59000/ End thread
   phys_free 77f59000 (detail=0x77f5eca0)
   ```

   It is exactly the same as GOOD


   BAD card does not respond to CMD8 - timeout

   ```
   |77f59000| sdcard_pio cmd 0 0 1ff0000
   |77f59000| sdcard cmd 0 response 0 0 0 0
   |77f59000| Reset card. ret = 0
   |77f59000| param[0] = 0
   |77f59000| error irq status =  0
   |77f59000| sdcard_pio cmd 81a 1aa 1ff0000
   |77f59000| sdcard_pio command stop (code=1)
   ```

   GOOD card responds to CMD8 properly

   ```
   |77f59000| sdcard_pio cmd 0 0 1ff0000
   |77f59000| sdcard cmd 0 response 0 0 0 0
   |77f59000| Reset card. ret = 0
   |77f59000| param[0] = 0
   |77f59000| error irq status =  0
   |77f59000| sdcard_pio cmd 81a 1aa 1ff0000
   |77f59000| sdcard cmd 81a response 1aa 0 0 0
   ```

1. When `BAD` card is inserted before powering on platform, it does not respond
   to any command. If it is being inserted during boot (or reinserted after
   boot) it responds to commands properly.
2. Cards that are in `inactive state` does not respond to any command. This may
   suggest that `BAD` card is for some reason in `inactive state` after
   power-on.
3. `CMD0` makes card to go into `idle state` from any other state (except from
   `inactive state`).
4. According to specification there should be no need to check if card is in
   fact in `idle state`. In this state only a few commands can be executed. We
   can send `CMD55` (which serves for prepending application-specific command).
   It responds with `R1` type response, which contains information about card's
   current state. `GOOD` card was in fact in `idle state` after reboot. `BAD`
   card has not been responding to this command even in case of multiple `CMD0`
   prepending it, no matter how long the time before those two commands was.
   Note that there is no specified time for entering in `idle state` so card
   should be ready to respond right after receiving `CMD0 `and no additional
   time window should be necessary.
5. There is no software way (no command) that forces the card to change state
   from `inactive state` to any other.
6. It can change state from `inactive` to `idle` after `Power Cycle` - drop
   voltage below 0.5V for at least 1ms or hot-plug (`BAD` card responds
   properly after reinsert). But the same (entering `idle state`) should take
   place during powering on a board.
7. We are up-to-date with mainline SeaBIOS when it comes to sdcard service.
