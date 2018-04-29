Overview
--------

This repository contain documentation and scripts that aim to help PC Engines
apuX platform users and developers to customize firmware to their needs.

Binary releases
---------------

For binary releases and release notes please visit [pcengines.github.io](https://pcengines.github.io/).


Building PC Engines firmware
----------------------------

Below instructions use dedicated Docker container to build firmware. Building
firmware is quite complex and to make sure there are no system dependencies we
rely on official coreboot SDK container.

```shell
git clone https://github.com/pcengines/pce-fw-builder.git
cd pce-fw-builder
./build.sh release <tag|branch> <platform>
```

`./build.sh` has advanced options for developers for more information please
check its help.

If you have any problems with `pce-fw-builder` please report through [project issue tracker](https://github.com/pcengines/pce-fw-builder/issues).

Flashing PC Engines firmware
----------------------------

Contribute
----------

Feel free to send pull request if you find bugs, typos or will have issues with
provided procedures.
