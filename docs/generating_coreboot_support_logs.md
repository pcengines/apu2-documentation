Generating coreboot support logs and sending them to verify
===========================================================

Intro
-----
* PLATFORM_IP used as example is `192.168.0.100`
* PLATFORM_SERIAL_DEVICE used as example is `/dev/ttyUSB0`

Requirements
------------
* OS with `cbmem` and `dmesg` installed on the target board
([`cbmem` installation instruction](./cbmem_building.md))
* Coreboot gerrit account: https://review.coreboot.org/
* Possibility to login to `root` user on the target board via SSH or enabled
coreboot boot logs redirection to the serial console
* Git (type on target device`apt-get install git -y` to install git on it)
* Internet connection

Common steps for every generating logs process variant
------------------------------------------------------
 
1. [Build coreboot ROM](./supported_coreboot_build.md). 

It's important to don't delete ROM image, because script used to generate 
support logs requires that image. Default directory of built ROM image is
`coreboot/build/`.

2. [Flash your device with flashrom usage](./flashrom_building.md).

If you have `flashrom` installed on your OS you can jump to 
`Flashing firmware with flashrom usage` section of instruction linked above.

3. Enter to the `coreboot` directory. 

It's important to run script from that directory, because it's root directory 
for coreboot scripts. If you try to run script from another directory there 
is a good chance that an error will be displayed and you will be prompted to 
change the directory to the correct one.

4. Choose one of the methods shown in sections below and generate coreboot 
support logs. 

`board_status.sh` is responsible for required logs collecting. 
It's placed in `coreboot/util/board_status` directory. But don't enter there. 
You have to stay in `coreboot` directory.

> Sending logs to verify is descibred in `Generating logs and sending them to 
verify` section.

Generating logs with SSH usage
------------------------------

Run `board_status.sh` script with `-r` option:

```
./util/board_status/board_status.sh -r <PLATFORM_IP>
```

Eg.:
```
./util/board_status/board_status.sh -r 192.168.0.100
```

You will be requested to enter `root` user password many times. It is 
uncomfortable for a longer period of time. To avoid this requirement follow 
[those steps](#enabling-possibility-to-SSH-login-without-entering-user-password)

After finishing that process information where logs were saved may be shown.
Example output:
```
output files are in /tmp/coreboot_board_status.XM0Q6Hn6/pcengines/alix2d/4.6-1329-g5bceca1c530c/2017-09-05T08_27_51Z
```
Generating logs and sending them to verify
------------------------------------------

To generate logs and then send them to coreboot supported boards repository
add `-u` option:

```
./util/board_status/board_status.sh -r <PLATFORM_IP> -u
```

Eg.:
```
./util/board_status/board_status.sh -r 192.168.0.100 -u
```
Logs will be sent to the https://review.coreboot.org/cgit/board-status.git/
repository automatically.

If you have no SSH key added correctly to coreboot gerrit you will be prompt to
enter your user name and HTTP password. To generate temporary HTTP password
enter to the settings of your coreboot [gerrit account](https://review.coreboot.org/#/settings/),
select `HTTP Password` section and click on `Generate Password` button. 
Generated password will appear next to the `Password` cell. You can use that 
password to upload support logs with `board_status.sh` script usage.

Generating logs with serial console usage
-----------------------------------------

There is possibility to get logs with serial port usage:
```
sudo ./util/board_status/board_status.sh -s <PLATFORM_SERIAL_DEVICE>
```

Eg.:
```
sudo ./util/board_status/board_status.sh -s /dev/ttyUSB0
```
That method is not that comfortable as SSH. Sometimes problems with logs 
formatting may occur. What is more you have to press `Enter` when 
you log to the OS, because first phase of logs collecting ends when grub
starts. Second phase of logs collecting start after pressing `Enter`.

Generating logs using earlier built ROM image
---------------------------------------------

If you have ROM image built earlier you can set custom directory to ROM image 
(default directory is `coreboot/build/`). To do that use `-i` option:

```
./util/board_status/board_status.sh -i <DIRECTORY_TO_ROM_IMAGE> -r <PLATFORM_IP>
```
Eg.:

```
./util/board_status/board_status.sh -i /tmp/coreboot.rom -r 192.168.0.100
```

# Enabling possibility to SSH login without entering user password
------------------------------------------------------------------

On master device:

1. Generate public/private rsa key pair:
```
ssh-keygen -t rsa
```
2. Send generated public id via SSH:
```
cat ~/.ssh/id_rsa.pub | ssh root@<PLATFORM_IP> 'cat >> .ssh/authorized_keys'
```
Eg.:
```
cat ~/.ssh/id_rsa.pub | ssh root@192.168.0.100 'cat >> .ssh/authorized_keys'
```

and enter the correct user password.

If the following error message appears:
```
bash: .ssh/authorized_keys: No such file or directory
```

That means you have to create `.ssh` folder. To do this type:
```
cd
mkdir .ssh
```
If there were no errors you should be able to connect to your target device via
SSH without entering user password.

Eg.:

```
arek@kal:~$ ssh root@192.168.0.112
Linux voyage 3.10.11 #2 SMP Thu Sep 7 11:36:30 UTC 2017 i586

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
 __  __
 \ \/ /___ __  __ ___  ___  ___    Useful Commands:
  \  // _ \\ \/ /,-_ |/ _ |/ -_)     remountrw - mount disk as read-write
   \/ \___/ \  / \___,\_  |\___|     remountro - mount disk as read-only
           _/_/        _'_|          remove.docs - remove all docs and manpages 
     { V o y a g e } - L i n u x     
      < http://linux.voyage.hk >   Version: 0.9.2 (Build Date 20131219)  
 
Last login: Tue Sep 12 10:16:21 2017 from 192.168.0.108
root@voyage:~# 

```

