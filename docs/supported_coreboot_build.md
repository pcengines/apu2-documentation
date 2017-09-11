Building firmware supported by coreboot
=======================================

Intro
-----
* Tested on Ubuntu 16.04 LTS
* CPU with 4 threads is usaded in instruction as an example
* Example IP address of PC Engines platform is `192.168.0.102`
* Git is required (type `sudo apt-get install git -y` to install git)

Coreboot ROM building process
-----------------------------

1. [Build environment container](https://github.com/pcengines/apu2-documentation/blob/master/docs/building_env.md).

2. Clone coreboot repository:

```
git clone https://review.coreboot.org/coreboot.git
```

And download submodules:
```
cd coreboot
git submodule update --init --checkout
```

> Changing files in downloaded directory is not required and it may cause that
built coreboot ROM will be labeled as `dirty`. This is an undesirable 
situation.

3. Run docker container:

```
docker run --rm     -v ${PWD}:/workdir     -t -i pc-engines/apu2 bash
```

4. Build crossgcc:

> It's required only at first running.

```
cd /workdir/coreboot
make crossgcc-i386 CPUS=4
```

> In place of `4` in `CPUS=4` type number of threads you want to use.


5. Configure your build:

If previously you built a ROM for another platform you should clean 
configuration. You can make it by typing:

```
make distclean
```

Configure your build parameters:
```
make menuconfig
```
Menu with build options should be shown.

Select correct options:
* For ALIX.1 series:
```
Mainboard ---> Mainboard vendor ---> PC Engines
Mainboard ---> Mainboard model  ---> ALIX.1C
Mainboard ---> ROM chip size	---> 1024 KB (1 MB)
```
* For ALIX.2, ALIX.3 series:
```
Mainboard ---> Mainboard vendor ---> PC Engines
Mainboard ---> Mainboard model  ---> ALIX.2D2 or 2D3
Mainboard ---> ROM chip size	---> 1024 KB (1 MB)
```
* For ALIX.6 series
```
Mainboard ---> Mainboard vendor ---> PC Engines
Mainboard ---> Mainboard model  ---> ALIX.6
Mainboard ---> ROM chip size	---> 1024 KB (1 MB)
```
* For APU1 series:
```
Mainboard ---> Mainboard vendor ---> PC Engines
Mainboard ---> Mainboard model  ---> APU1
```
* For APU2 series
```
Mainboard ---> Mainboard vendor ---> PC Engines
Mainboard ---> Mainboard model  ---> APU2	
```

To enable creating coreboot boot timestamps table select:
```
General setup ---> [ ]Create a table of timestamps collected during boot
```
Then press `Y` key to enable that function. If enabled `*` should appear:
```
[*]Create a table of timestamps collected during boot
```

6. Build coreboot ROM file:
```
make CPUS=4
```
> In place of `4` in `CPUS=4` type number of threads you want to use.

Built ROM should be in `build` directory and it may be named `coreboot.rom`.

7. You can now send it to the target device. E.g. with `scp` usage:

```
scp build/coreboot.rom root@192.168.0.102:/tmp
```

