## Intro

Following document describes release process for new versions of firmware for PC
Engines APU2 platform. It is intended for developers who want to create fully
featured binaries and test those with various versions of sortbootorder,
SeaBIOS, memtest86+ or iPXE.

Please note that flashing without recovery procedure is not recommended and we
are not responsible for any damage that inexperienced person can do to the
system.

## Use repo tool to initialize set of repositories

```
mkdir apu2_fw_rel
cd apu2_fw_rel

repo init -u git@github.com:mek-x/pcengines_manifests.git -b refs/tags/<tag_release>
# or
repo init -u git@github.com:mek-x/pcengines_manifests.git -b <branch_name>

repo sync --force-sync
```

where:
* `<tag_release>` - is the release version number (e.g. `v4.5.3.1`)
* `<branch_name>` - is the release branch (i.e. `coreboot-4.0.x` for legacy,
and `coreboot-4.5.x` for mainline

You can look-up changes, available branches and release tags on this
[github repository](https://github.com/mek-x/pcengines_manifests).

## Build container

This is to avoid impact of system on build results:

```
docker build -t pcengines/apu2 apu2/apu2-documentation
```

This step could be omitted, if there was build done before (container already
exists).

## Build release

Assuming you initialized the repo with *mainline* release:

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build-ml menuconfig
```

Please choose:

```
Mainboard -> Mainboard vendor -> PC Engines
Mainboard -> Mainboard model  -> APU2
```

All other pieces will be set according to recent release configuration.
*coreboot* image will start to build after exiting menu.

For *legacy* release you can use this command. You don't need to run
`menuconfig` first, because *legacy* release get's initialized by custom
`.config` file:
```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build
```

There are also additional commands like:
```
# distclean && menuconfig
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build-ml distclean

#rm -rf .config* && menuconfig
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build-ml cfgclean

#custom make parameters
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh build-ml custom <param>
```

After successful build, you can flash target device.

## Flash release

Note that below script assume that you have ssh enabled connection with target
device and destination OS [APU2 image builder](https://github.com/pcengines/
apu2-documentation#building-firmware-using-apu2-image-builder)
or other distro that have working `flashrom` available in `PATH`. Without keys
added you will see question about password couple times during flashing.

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh flash <user>@<ip_address>
```

For mainline:

```
./apu2/apu2-documentation/scripts/apu2_fw_rel.sh flash-ml <user>@<ip_address>
```

Best way is to use `root` as `<user>` because it can have no problem with low
level access.

Please do not hesitate with providing feedback or contributing fixes.

## Known issues

### using repo with coreboot show errors like:

```
fatal: Not a git repository (or any parent up to mount point /coreboot)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
```

Since it use `git` commands to create build timestamp.

#### flashing doesn't work

```
[21:51:53] pietrushnic:apu2_fw_rel $ ../apu2-documentation/scripts/apu2_fw_rel.sh flash-ml pcengines@192.168.0.103
flash-ml pcengines@192.168.0.103
The authenticity of host '192.168.0.103 (192.168.0.103)' can't be established.
(...)
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.0.103' (ECDSA) to the list of known hosts.
bash: remountrw: command not found
coreboot.rom                                                                                                                                                                                                100% 8192KB   8.0MB/s   00:00
sudo: no tty present and no askpass program specified
sudo: no tty present and no askpass program specified
```

### scripts finish with error

If you see something like this:
```
dirname: missing operand
Try 'dirname --help' for more information.
dirname: missing operand
Try 'dirname --help' for more information.
docker: Error response from daemon: Invalid volume spec ":": Invalid volume specification: ':'.
See 'docker run --help'.
```

Try to run:
```
eval $(ssh-agent)
ssh-add
```
