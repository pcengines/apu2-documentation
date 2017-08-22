# Configuring Voyage Linux netinst

## Prepare image

Get the live CD from
[here](http://mirror.voyage.hk/download/ISO/amd64/voyage-0.11.0_amd64.iso)

Then mount it wherever You like:
```
mount -o loop  voyage-0.11.0_amd64.iso /mnt/dir
```

Extract to nfs exported directory:
```
cp -rp /mnt/dir /path/to/nfs/dir
```
## Prepare PXE

Modify PXE menu.cfg:
>voyage/ directory is a directory in tftp path on tftp server. Also remember to change IP of the nfsroot server


```
label voyage
	menu label ^Voyage-netinst
	kernel voyage/vmlinuz
	append initrd=voyage/initrd.img boot=live netboot=nfs root=/dev/nfs rw ip=dhcp nfsroot=192.168.0.109:/home/miczyg/nfs --- console=ttyS0,115200 earlyprint=serial,ttyS0,115200
```
Copy the `vmlinuz` and `initrd.img` to `/path/to/tftpboot/voyage`

## Installation on target APU2

Boot APU with iPXE and choose the correct option in menu.
Log in as `root` with password `voyage` and run:
```
/usr/local/sbin/voyage.update
```

Follow steps in [Voyage Linux install](voyage_linux_sd_card_install.md) section 4.
>I assume that any SD card, USB drive etc. is plugged in APU

Now Voyage Linux is installed to the drive chosen in installation process. Reboot APU and choose to boot from this drive. 