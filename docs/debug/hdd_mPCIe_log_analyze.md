
### coldboot

* mpcie1 from coldboot:


  ```
  [2016-10-22 16:04:16] /dff57000\ Start thread
  [2016-10-22 16:04:16] |dff57000| AHCI/1: probing
  [2016-10-22 16:04:16] |dff57000| AHCI/1: link up
  [2016-10-22 16:04:16] |dff57000| AHCI/1: send cmd ...
  [2016-10-22 16:04:48] |dff57000| WARNING - Timeout at ahci_command:154!
  [2016-10-22 16:04:48] |dff57000| AHCI/1: send cmd ...
  [2016-10-22 16:05:20] |dff57000| WARNING - Timeout at ahci_command:154!
  [2016-10-22 16:05:20] |dff57000| phys_free dff5a400 (detail=0xdff5a3d0)
  [2016-10-22 16:05:20] |dff57000| phys_free dff5a200 (detail=0xdff5a3a0)
  [2016-10-22 16:05:20] |dff57000| phys_free dff5a100 (detail=0xdff5a370)
  [2016-10-22 16:05:20] |dff57000| phys_free dff5ac50 (detail=0xdff5ac20)
  [2016-10-22 16:05:20] \dff57000/ End thread
  [2016-10-22 16:05:20] phys_free dff57000 (detail=0xdff5a340)
  ```

mpcie2 from coldboot:


  ```
  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ start thread
  |dff57000| ahci_port_detect
  |dff57000| ahci/1: probing
  |dff57000| ahci/1: link up
  |dff57000| ahci/1: send cmd ...
  |dff57000| WARNING - Timeout at ahci_command:154!
  |dff57000| AHCI/1: send cmd ...
  |dff57000| WARNING - Timeout at ahci_command:154!
  |dff57000| phys_free dff5a000 (detail=0xdff5a7a0)
  |dff57000| phys_free dff5a600 (detail=0xdff5a770)
  |dff57000| phys_free dff5a500 (detail=0xdff5a740)
  |dff57000| phys_free dff5ac20 (detail=0xdff5a7d0)
  \dff57000/ End thread
  phys_free dff57000 (detail=0xdff5a710)
  ```

After coldboot, mPCIe1 and mPCIe2 behaviour is the same (AHCI Timeout). But in
mPCIe2 case you can not fully load into OS: it reboots after: `tsc unst`

### reboot

* mPCIe1 after reboot:

  ```
  [2016-10-22 16:07:10] phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a340)
  [2016-10-22 16:07:10] /dff57000\ Start thread
  [2016-10-22 16:07:10] |dff57000| AHCI/1: probing
  [2016-10-22 16:07:10] |dff57000| AHCI/1: link up
  [2016-10-22 16:07:10] |dff57000| AHCI/1: send cmd ...
  [2016-10-22 16:07:10] |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  [2016-10-22 16:07:10] |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  [2016-10-22 16:07:10] |dff57000| AHCI/1: send cmd ...
  [2016-10-22 16:07:11] |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  [2016-10-22 16:07:11] |dff57000| AHCI/1: ... finished, status 0x58, OK
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae60 (detail=0xdff5ae30)
  [2016-10-22 16:07:11] |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,5/*@0/drive@1/disk@0
  [2016-10-22 16:07:11] |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  [2016-10-22 16:07:11] |dff57000| AHCI/1: Set transfer mode to UDMA-6
  [2016-10-22 16:07:11] |dff57000| AHCI/1: send cmd ...
  [2016-10-22 16:07:11] |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  [2016-10-22 16:07:11] |dff57000| AHCI/1: ... finished, status 0x50, OK
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df18 size=68 align=10 ret=f0500 (detail=0xdff5add0)
  [2016-10-22 16:07:11] |dff57000| phys_free dff5ac50 (detail=0xdff5ac20)
  [2016-10-22 16:07:11] |dff57000| phys_free dff5a400 (detail=0xdff5a3d0)
  [2016-10-22 16:07:11] |dff57000| phys_free dff5a200 (detail=0xdff5a3a0)
  [2016-10-22 16:07:11] |dff57000| phys_free dff5a100 (detail=0xdff5a370)
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df1c size=1024 align=400 ret=dffad000 (detail=0xdff61250)
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df1c size=256 align=100 ret=dffad800 (detail=0xdff61220)
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df1c size=256 align=100 ret=dffabf00 (detail=0xdff61140)
  [2016-10-22 16:07:11] |dff57000| AHCI/1: registering: "AHCI/1: ST1000LM014-SSHD-8GB ATA-9 Hard-Disk (931 GiBytes)"
  [2016-10-22 16:07:11] |dff57000| phys_alloc zone=0xdff6df10 size=24 align=10 ret=dff61200 (detail=0xdff61110)
  [2016-10-22 16:07:11] |dff57000| Registering bootable: AHCI/1: ST1000LM014-SSHD-8GB ATA-9 Hard-Disk (931 GiBytes) (type:2 prio:103 data:f0500)
  [2016-10-22 16:07:11] \dff57000/ End thread
  [2016-10-22 16:07:11] phys_free dff57000 (detail=0xdff5a340)
  ```

* mPCIe2 after reboot:

  ```
  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  |dff57000| AHCI/1: ... finished, status 0x50, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  |dff57000| AHCI/1: ... finished, status 0x50, OK
  |dff57000| ahci_command rc = 0

   // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  |dff57000| AHCI/1: ... finished, status 0x50, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  |dff57000| AHCI/1: ... finished, status 0x50, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0xffffffff, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  |dff57000| psfis
  |dff57000| AHCI/1: ... intbits 0x2, status 0x58 ...
  |dff57000| AHCI/1: ... finished, status 0x58, OK
  |dff57000| phys_alloc zone=0xdff6df10 size=80 align=10 ret=dff5ae10 (detail=0xdff5ade0)
  |dff57000| Searching bootorder for: /pci@i0cf8/pci-bridge@2,1/*@0/drive@1/disk@0
  |dff57000| AHCI/1: supported modes: udma 6, multi-dma 2, pio 4
  |dff57000| AHCI/1: Set transfer mode to UDMA-6
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x1, status 0x50 ...
  |dff57000| AHCI/1: ... finished, status 0x50, OK
  |dff57000| ahci_command rc = 0

  // REBOOTS HERE

  phys_alloc zone=0xdff6df10 size=4096 align=1000 ret=dff57000 (detail=0xdff5a710)
  /dff57000\ Start thread
  |dff57000| ahci_port_detect
  |dff57000| AHCI/1: probing
  |dff57000| AHCI/1: link up
  |dff57000| AHCI/1: send cmd ...
  |dff57000| rfis
  |dff57000| AHCI/1: ... intbits 0x40000001, status 0x51 ...
  |dff57000| AHCI/1: ... finished, status 0x51, ERROR 0x4
  |dff57000| AHCI/1: send cmd ...
  ```

  After reboot, in mPCIe1 slot HDD gets registered, while in mPCIe2 slot it does
  not - it reboots during AHCI thread.

  It is not fully consistent. `intbits` and `status` values varies beteen
  following reboots. `rfis` and `psfis` prints added to indicate `FIS` type:
  `Register- Device to Host` or `PIO Setup - Device to Host`. Reboot appears
  even if thread flow is identical to this from mPCIe1, where reboot does
  not occur.

  Source of reboot is not yet discovered. It prints `rc=0` but probably does
  not reach to `return 0` (function above, which is calling this one, does
  not print returned value). This `else` does not matter since it is not
  executing in this case.

  This is done in file
  [seabios/src/hw/ahci.c](https://github.com/pcengines/seabios/blob/apu_support/src/hw/ahci.c),
  function `ahci_port_setup` that starts with line 421.

  ```
          rc = ahci_command(port, 1, 0, 0, 0);

          dprintf(1, "ahci_command rc = %x \n", rc);

          if (rc < 0) {
              dprintf(1, "AHCI/%d: Set transfer mode failed.\n", port->pnr);
          }
      }
  else
  {
      // found cdrom (atapi)
      port->drive.type = DTYPE_AHCI_ATAPI;
      port->drive.blksize = CDROM_SECTOR_SIZE;
      port->drive.sectors = (u64)-1;
      u8 iscd = ((buffer[0] >> 8) & 0x1f) == 0x05;
      if (!iscd) {
          dprintf(1, "AHCI/%d: atapi device isn't a cdrom\n", port->pnr);
          return -1;
      }
      port->desc = znprintf(MAXDESCSIZE
                            , "DVD/CD [AHCI/%d: %s ATAPI-%d DVD/CD]"
                            , port->pnr
                            , ata_extract_model(model, MAXMODEL, buffer)
                            , ata_extract_version(buffer));
      port->prio = bootprio_find_ata_device(ctrl->pci_tmp, pnr, 0);
  }
  return 0;
  ```

  Function `ahci_port_detect`, which is calling function `ahci_port_setup`
  presented above. Below prints are not present in logs

  ```
  static void
  ahci_port_detect(void *data)
  {
      struct ahci_port_s *port = data;
      int rc;

      dprintf(2, "AHCI/%d: probing\n", port->pnr);
      ahci_port_reset(port->ctrl, port->pnr);
      rc = ahci_port_setup(port);

      dprintf(1, "ahci_port_setup rc = %d \n", rc);
  ```
