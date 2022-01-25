PC Engines firmware release process
===================================

This document describes the process of monthly development and release cycle of
PC Engines firmware.

- [PC Engines firmware release process](#pc-engines-firmware-release-process)
	- [Task tagging](#task-tagging)
	- [coreboot mainline](#coreboot-mainline)
		- [coreboot mainline development and release branches](#coreboot-mainline-development-and-release-branches)
		- [coreboot mainline feature/bug fix development](#coreboot-mainline-featurebug-fix-development)
		- [Steps for new coreboot mainline release](#steps-for-new-coreboot-mainline-release)
	- [coreboot legacy](#coreboot-legacy)
		- [coreboot legacy development and release branches](#coreboot-legacy-development-and-release-branches)
		- [coreboot legacy feature/bug fix development](#coreboot-legacy-featurebug-fix-development)
		- [Steps for new coreboot legacy release](#steps-for-new-coreboot-legacy-release)
	- [SeaBIOS](#seabios)
		- [SeaBIOS development](#seabios-development)
		- [SeaBIOS release](#seabios-release)
	- [sortbootorder](#sortbootorder)
		- [sortbootorder development](#sortbootorder-development)
		- [sortbootorder release](#sortbootorder-release)
	- [pcengines.github.io](#pcenginesgithubio)
		- [pcengines.github.io branches](#pcenginesgithubio-branches)
		- [Steps for new site release](#steps-for-new-site-release)

## Task tagging

Proper tagging of any stories or tasks in project will let us automate
financial processes. Just add proper tag at the beginning of any story/task
you create in jira according to following logic:

* [HWD] - hardware issues
* [DEV] - code development, debugging, code review
* [REL] - release
* [MNG] - management, communiication, logistics
* [WEB] - website, forum, CI infrastructure
* [TST] - automated validation, test development, RTE

## coreboot mainline

### coreboot mainline development and release branches

* `master` - keeps track of [coreboot's master branch](https://review.coreboot.org/cgit/coreboot.git/log/)
* `release` - where all releases are merged
* `develop` - where current development takes place periodically synced with
  coreboot master
* `rel_x.y.z.w` - release branches, where:
    * `x` is coreboot major version
    * `y` is coreboot minor version
    * `z` is coreboot patch number
    * `w` is PC Engines firmware fork patch number counted from `0`
* `feature_branch` - sample feature branch name for workflow explanation needs

### coreboot mainline feature/bug fix development

We are in favor of [Test Driven Bug Fixing (TDBF)](https://geeknarrator.com/2018/01/28/test-driven-bug-fixing-guidelines/).

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Pull `coreboot's master branch` to `master`

```
# assuming on PC Engines master branch
git checkout master
git fetch https://review.coreboot.org/coreboot.git && git merge FETCH_HEAD
git push
```

3. Merge `master` to `develop`

```
git checkout develop
git pull
git merge master
# resolve conflicts and test the build
git push
```

4. Create new branch `feature_branch` from `develop`

```
git checkout -b feature_branch
```

5. Commit changes to `feature_branch`
6. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
7. Submit PR to `develop`


### Steps for new coreboot mainline release

1. Checkout new branch `rel_x.y.z.w` from recent commit on `release`

```
git checkout release
git checkout -b rel_x.y.w.z
```

2. Merge current `develop` to `rel_x.y.z.w`

```
git checkout rel_x.y.z.w
git merge develop
git push -u origin rel_x.y.z.w
```

3. End of month we close merge window
4. Prepare the CHANGELOG update on separate branch and set up a PR to
   `rel_x.y.z.w`:

The CHANGELOG update must contain the following:

- new version entry with following format

```
## [vx.y.z.w] - YYYY-MM-DD
### Fixed

### Added

### Changed
```

Where `vx.y.z.w` is the current version to be released. The new version entry
should be placed right under `## [Unreleased]` section and before last release
entry. Each section `Fixed, Added, Changed` should contain the unordered list of
changes since the last release. The content of changes should match one of these
three categories. Typically changes are related to merged PRs with internal bug
fixes and new features. `YYYY-MM-DD` is the release date (date of placing the
tag).

- updated link to release comparison (example v4.9.0.8 release)

Before:
```
[Unreleased]: https://github.com/pcengines/coreboot/compare/v4.9.0.7...develop
[v4.9.0.7]: https://github.com/pcengines/coreboot/compare/v4.9.0.6...v4.9.0.7
[v4.9.0.6]: https://github.com/pcengines/coreboot/compare/v4.9.0.5...v4.9.0.6
```

After:
```
[Unreleased]: https://github.com/pcengines/coreboot/compare/v4.9.0.8...develop
[v4.9.0.8]: https://github.com/pcengines/coreboot/compare/v4.9.0.7...v4.9.0.8
[v4.9.0.7]: https://github.com/pcengines/coreboot/compare/v4.9.0.6...v4.9.0.7
[v4.9.0.6]: https://github.com/pcengines/coreboot/compare/v4.9.0.5...v4.9.0.6
```

Be sure to check whether link appears in the preview of markdown.

4. Update the miniconfigs in configs directory:

- take old config:

```
cp configs/config.pcengines_apux .config
make olddefconfig
```

- update the config with necessary changes:

```
make menuconfig
```

Update the local version in `General setup -> Local version string` to
`vx.y.z.w`. Update the payloads version (SeaBIOS, sortbootorder) if a new
version was released recently.

- save new config:

```
# exit the menuconfig and save changes, then
make savedefconfig
cp defconfig configs/config.pcengines_apux
```

- repeat above steps for all apu platforms (substitute `x` in
  `config.pcengines_apux` with 1-5).
- commit the changes and push to `rel_x.y.z.w`

5. Perform automated regression testing on `rel_x.y.z.w` including all new
   tests
6. Fix all required issues and repeat point 4 until fixed - this doesn't mean
   all tests pass, this mean that approved set passed
7. If results are accepted merge it to `release` branch via PR (or ask
   teamleader to verify and merge the PR).
8. Add tag `vx.y.z.w`, which should trigger CI and publish binaries.

```
git checkout release
git pull
git tag vx.y.z.w
git push -u origin vx.y.z.w
```

9. Merge release branch to develop

```
git checkout release
git pull
git checkout develop
git merge release
git push
```

## coreboot legacy

### coreboot legacy development and release branches

* `coreboot-4.0.x` - where all releases are merged
* `rel_4.0.x` - release branches, where:
    * `x` is coreboot patch number
* `feature_branch` - sample feature branch name for workflow explanation needs

### coreboot legacy feature/bug fix development

We are in favor of [Test Driven Bug Fixing (TDBF)](https://geeknarrator.com/2018/01/28/test-driven-bug-fixing-guidelines/).

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Create a new legacy release branch `rel_4.0.x`

```
git checkout coreboot-4.0.x
git pull
git checkout -b rel_4.0.x
git push -u origin rel_4.0.x
```

4. Create new branch `feature_branch` from `rel_4.0.x`

```
git checkout rel_4.0.x
git pull
git checkout -b feature_branch
```

5. Commit changes to `feature_branch`
6. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
7. Submit PR to `rel_4.0.x`

### Steps for new coreboot legacy release

1. End of month we close merge window on `rel_4.0.x`
2. Prepare the CHANGELOG update on separate branch and set up a PR to
   `rel_4.0.x`:

The CHANGELOG update must contain the following:

- new version entry with following format

```
## [v4.0.x] - YYYY-MM-DD
### Fixed

### Added

### Changed
```

Where `v4.0.x` is the current version to be released. The new version entry
should be placed right under `## [Unreleased]` section and before last release
entry. Each section `Fixed, Added, Changed` should contain the unordered list of
changes since the last release. The content of changes should match one of these
three categories. Typically changes are related to merged PRs with internal bug
fixes and new features. `YYYY-MM-DD` is the release date (date of placing the
tag).

- updated link to release comparison (example v4.0.28 release)

Before:
```
[Unreleased]: https://github.com/pcengines/coreboot/compare/v4.0.27...coreboot-4.0.x
[v4.0.27]: https://github.com/pcengines/coreboot/compare/v4.0.26...v4.0.27
[v4.0.26]: https://github.com/pcengines/coreboot/compare/v4.0.25...v4.0.26
```

After:
```
[Unreleased]: https://github.com/pcengines/coreboot/compare/v4.0.28...coreboot-4.0.x
[v4.0.28]: https://github.com/pcengines/coreboot/compare/v4.0.27...v4.0.28
[v4.0.27]: https://github.com/pcengines/coreboot/compare/v4.0.26...v4.0.27
[v4.0.26]: https://github.com/pcengines/coreboot/compare/v4.0.25...v4.0.26
```

Be sure to check whether link appears in the preview of markdown.

3. Update the configs in configs directory:

- take old config:

```
cp configs/config.pcengines_apux .config
```

- update the config with necessary changes:

```
make menuconfig
```

Update the payloads version (SeaBIOS, sortbootorder) if a new
version was released recently.

- save new config:

```
# exit the menuconfig and save changes, then
cp .config configs/config.pcengines_apux
```

- repeat above steps for all apu platforms (substitute `x` in
  `config.pcengines_apux` with 2-5).
- commit the changes and push to `rel_4.0x`

4. Perform automated regression testing on `rel_4.0.x` including all new
   tests
5. Fix all required issues and repeat point 4 until fixed - this doesn't mean
   all tests pass, this mean that approved set passed
6. If results are accepted merge it to `coreboot-4.0.x` branch via PR (or ask
   teamleader to verify and merge the PR).
7. Add tag `v4.0.x`, which should trigger CI and publish binaries.

```
git checkout coreboot-4.0.x
git pull
git tag v4.0.x
git push -u origin v4.0.x
```

## SeaBIOS

### SeaBIOS development

* `master` - keeps track of [SeaBIOS's master branch](https://review.coreboot.org/cgit/seabios.git/log/)
* `apu_support` - where all releases are merged
* `rel_1.xx.y.z` - release branches, where:
    * `x` is SeaBIOS minor version
    * `y` is SeaBIOS patch version
    * `z` is PC Engines firmware fork patch number counted from `0`

When developing new features or fixing bugs, follow these steps:

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Create a new release branch `rel_1.xx.y.z`

```
git checkout apu_supportv
git pull
git checkout -b rel_1.xx.y.z
git push -u origin rel_1.xx.y.z
```

3. Create a new feature/bug fix branch from `rel_1.xx.y.z`:

```
git checkout rel_1.xx.y.z
git pull
git checkout -b feature branch
```

4. Commit changes to `feature_branch`
5. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
6. Submit PR to `rel_1.xx.y.z`.

### SeaBIOS release

1. End of month close merge window for bug fixing and feature development on
   `rel_1.xx.y.z`.
2. Prepare the CHANGELOG update on separate branch and set up a PR to
   `rel_1.xx.y.z`.

The CHANGELOG update must contain the following:

- new version entry with following format

```
## [rel-1.xx.y.z] - YYYY-MM-DD
### Fixed

### Added

### Changed
```

Where `rel-1.xx.y.z` is the current version to be released. Notice the format,
the release branch has an underscore `_`, but release tag must have a dash `-`.
The new version entry should be placed right under `## [Unreleased]` section and
before last release entry. Each section `Fixed, Added, Changed` should contain
the unordered list of changes since the last release. The content of changes
should match one of these three categories. Typically changes are related to
merged PRs with bug fixes and new features. `YYYY-MM-DD` is the release date
(date of placing the tag).

- updated link to release comparison (example rel-1.12.1.4 release)

Before:
```
[Unreleased]: https://github.com/pcengines/seabios/compare/rel-1.12.1.3...apu_support
[rel-1.12.1.3]: https://github.com/pcengines/seabios/compare/rel-1.12.1.2...rel-1.12.1.3
[rel-1.12.1.2]: https://github.com/pcengines/seabios/compare/rel-1.12.1.1...rel-1.12.1.2
```

After:
```
[Unreleased]: https://github.com/pcengines/seabios/compare/rel-1.12.1.4...apu_support
[rel-1.12.1.4]: https://github.com/pcengines/seabios/compare/rel-1.12.1.3...rel-1.12.1.4
[rel-1.12.1.3]: https://github.com/pcengines/seabios/compare/rel-1.12.1.2...rel-1.12.1.3
[rel-1.12.1.2]: https://github.com/pcengines/seabios/compare/rel-1.12.1.1...rel-1.12.1.2
```

Be sure to check whether link appears in the preview of markdown.

3. Merge the branch with CHANGELOG to `rel-1.xx.y.z`.
4. If everything is correct merge branch `rel-1.xx.y.z` into `apu_support` via
   PR (or ask teamleader to verify and merge the PR.)
5. Place a new `rel-1.xx.y.z` tag on `apu_support`.

```
git checkout apu_support
git pull
git tag rel-1.xx.y.z
git push -u origin rel-1.xx.y.z
```

> SeaBIOS is rebased with official repository only on special demand and on
> stable releases.

## sortbootorder

### sortbootorder development

* `master` - main release branch
* `rel_x.y.z` - release branches, where:
    * `x` is sortbootorder major version
    * `y` is sortbootorder minor version
    * `z` is sortbootorder patch version

When developing new features or fixing bugs, follow these steps:

1. Create automated test that validate feature or reproduce bug - test fails at
   this point
2. Create a new release branch `rel_x.y.z`

```
git checkout master
git pull
git checkout -b rel_x.y.z
git push -u origin rel_x.y.z
```

3. Create a new feature/bug fix branch from `rel_x.y.z`:

```
git checkout rel_x.y.z
git pull
git checkout -b feature branch
```

4. Commit changes to `feature_branch`
5. Run regression tests and fix bugs - test written in point 1 should pass at
   this point
6. Submit PR to `rel_x.y.z`.

### sortbootorder release

1. End of month close merge window for bug fixing and feature development on
   `rel_x.y.z`.
2. Prepare the CHANGELOG update on separate branch and set up a PR to
   `rel_x.y.z`.

The CHANGELOG update must contain the following:

- new version entry with following format

```
## [vx.y.z] - YYYY-MM-DD
### Fixed

### Added

### Changed
```

Where `vx.y.z` is the current version to be released. The new version entry
should be placed right under `## [Unreleased]` section and before last release
entry. Each section `Fixed, Added, Changed` should contain the unordered list of
changes since the last release. The content of changes should match one of these
three categories. Typically changes are related to merged PRs with bug fixes and
new features. `YYYY-MM-DD` is the release date (date of placing the tag).

- updated link to release comparison (example v4.6.16 release)

Before:
```
[Unreleased]: https://github.com/pcengines/sortbootorder/compare/v4.6.15...master
[v4.6.15]: https://github.com/pcengines/sortbootorder/compare/v4.6.14...v4.6.15
[v4.6.14]: https://github.com/pcengines/sortbootorder/compare/v4.6.13...v4.6.14
[v4.6.13]: https://github.com/pcengines/sortbootorder/compare/v4.6.12...v4.6.13
```

After:
```
[Unreleased]: https://github.com/pcengines/sortbootorder/compare/v4.6.16...master
[v4.6.16]: https://github.com/pcengines/sortbootorder/compare/v4.6.15...v4.6.16
[v4.6.15]: https://github.com/pcengines/sortbootorder/compare/v4.6.14...v4.6.15
[v4.6.14]: https://github.com/pcengines/sortbootorder/compare/v4.6.13...v4.6.14
[v4.6.13]: https://github.com/pcengines/sortbootorder/compare/v4.6.12...v4.6.13
```

Be sure to check whether link appears in the preview of markdown.

3. Merge the branch with CHANGELOG to `rel_x.y.z`.
4. If everything is correct merge branch `rel_x.y.z` into `master` via
   PR (or ask teamleader to verify and merge the PR.)
5. Place a new `vx.y.z` tag on `master`.

```
git checkout master
git pull
git tag vx.y.z
git push -u origin vx.y.z
```

## pcengines.github.io

The `pcengines.github.io` site gathers all coreboot releases for PC Engines.
After each new coreboot release, the site is updated with new binaries and
release notes.

### pcengines.github.io branches

- `master` - the main branch which the site is rendered from
- `rel_vx.y.z.w` - release branch named from recent mainline coreboot release

### Steps for new site release

1. Create a new release branch `rel_vx.y.z.w` from `master`:

```
git checkout master
git pull
git checkout -b rel_vx.y.z.w
```

2. Update the `index.html` file with new mainline and legacy releases:

For mainline releases, use the [python script](https://github.com/pcengines/pcengines.github.io/blob/master/gen-index.py)

```
python gen-index.py
Coreboot version (e.g. 'v4.9.0.4'): 'v4.9.0.8'
SeaBIOS version (e.g. 'rel-1.12.1.1') or leave empty if doesn't change: 'rel-1.12.1.2'
sortbootorder version (e.g. 'v4.6.13') or leave empty if doesn't change: 'v4.6.14'
release date (format `YYYY-MM-DD`) or leave empty (today): '2019-08-08'

STATUS: `index.html` file generated successfully
```

> legacy release are not supported by the script yet.

The script automates the insertion of new release entry by doing the following:

- add new link to the [versions list](https://github.com/pcengines/pcengines.github.io/blob/master/index.html#L141)

Each new release should have a new href `#mr-xx` where `xx` is the next order
number. The list shoudl also display the new version number:
`<li><a href="#mr-25">v4.9.0.8</a></li>`.

- inserts the following entry at the top of release notes:

```
   <div class="smaller-margin" id="mr-24">
            <h2 class="text-middle">Mainline releases</h2>
            <!-- h2 tag needs to be moved to the newest version -->
            <h4><a target="_blank" href="https://github.com/pcengines/coreboot/compare/v4.9.0.6...v4.9.0.7">v4.9.0.7</a></h4>
        </div>

        <div class="dimmed-text">
            <p>Release date: '2019-07-09'</p>
        </div>

        <ul>
            <li>Fixed/added:</li>
            <ol>
                <li>rebased with official coreboot repository commit c32ccb7</li>
                <li><a href="https://github.com/pcengines/apu2-documentation/blob/master/docs/tianocore_build.md">prepared integration of tianocore payload allowing to boot UEFI aware systems
                </a></li>
                <li>removed incorrectly assigned clock request mappings</li>
                <li>disabled IPv6 in iPXE that often caused the dhcp/autoboot command to time out</li>
                <li><a href="https://github.com/pcengines/seabios/blob/apu_support/CHANGELOG.md#rel-11213---2019-07-05">updated SeaBIOS to rel-1.12.1.3</a></li>
                <li><a href="https://github.com/pcengines/sortbootorder/blob/master/CHANGELOG.md#v4615---2019-07-05">updated sortbootorder to v4.6.15</a></li>
            </ol>
            <li>Known issues:</li>
            <ol>
                <li><a href="https://github.com/pcengines/apu2-documentation/issues/115">some PCIe cards are not detected on certain OSes and/or in certain mPCIe slots</a></li>
                <li><a href="https://github.com/pcengines/seabios/issues/30">booting with 2 USB 3.x sticks plugged in apu4
                        sometimes results in detecting only 1 stick</a></li>
                <li><a href="https://github.com/pcengines/seabios/issues/29">certain USB 3.x sticks happen to not appear in
                        boot menu</a></li>
                <li><a href="https://github.com/pcengines/apu2-documentation/issues/109">booting Xen is unstable</a></li>
                <li><a href="https://github.com/pcengines/coreboot/issues/321">watchdog cannot be enabled on apu3</a></li>
            </ol>
        </ul>

        <div class="source-code-links-binaries">
            <div class="source-code-column">
                <div class="smaller-margin">
                    <p>Binaries:</p>
                </div>
                <ul>
                    <li><a class="sha-button" href="https://3mdeb.com/open-source-firmware/pcengines/apu1/apu1_v4.9.0.7.rom">apu1 v4.9.0.7</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu1/apu1_v4.9.0.7.SHA256" class="sha-button">SHA256</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu1/apu1_v4.9.0.7.SHA256.sig" class="sha-button">SHA256.sig</a></li>
                    <li><a class="sha-button" href="https://3mdeb.com/open-source-firmware/pcengines/apu2/apu2_v4.9.0.7.rom">apu2 v4.9.0.7</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu2/apu2_v4.9.0.7.SHA256" class="sha-button">SHA256</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu2/apu2_v4.9.0.7.SHA256.sig" class="sha-button">SHA256.sig</a></li>
                    <li><a class="sha-button" href="https://3mdeb.com/open-source-firmware/pcengines/apu3/apu3_v4.9.0.7.rom">apu3 v4.9.0.7</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu3/apu3_v4.9.0.7.SHA256" class="sha-button">SHA256</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu3/apu3_v4.9.0.7.SHA256.sig" class="sha-button">SHA256.sig</a></li>
                    <li><a class="sha-button" href="https://3mdeb.com/open-source-firmware/pcengines/apu4/apu4_v4.9.0.7.rom">apu4 v4.9.0.7</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu4/apu4_v4.9.0.7.SHA256" class="sha-button">SHA256</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu4/apu4_v4.9.0.7.SHA256.sig" class="sha-button">SHA256.sig</a></li>
                    <li><a class="sha-button" href="https://3mdeb.com/open-source-firmware/pcengines/apu5/apu5_v4.9.0.7.rom">apu5 v4.9.0.7</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu5/apu5_v4.9.0.7.SHA256" class="sha-button">SHA256</a><a href="https://3mdeb.com/open-source-firmware/pcengines/apu5/apu5_v4.9.0.7.SHA256.sig" class="sha-button">SHA256.sig</a></li>
                </ul>
            </div>
            <div class="source-code-column">
                <div class="smaller-margin">
                    <p>Source code:</p>
                </div>
                <ul>
                    <li><a target="_blank" href="https://github.com/pcengines/coreboot/compare/v4.9.0.6...v4.9.0.7">coreboot v4.9.0.7</a></li>
                    <li><a target="_blank" href="https://github.com/pcengines/seabios/compare/rel-1.12.1.2...'rel-1.12.1.3'">SeaBIOS 'rel-1.12.1.3'</a></li>
                    <li><a target="_blank" href="https://github.com/pcengines/sortbootorder/compare/v4.6.14...'v4.6.15'">sortbootorder 'v4.6.15'</a></li>
                    <li><a target="_blank" href="https://git.ipxe.org/ipxe.git">ipxe</a></li>
                    <li><a target="_blank" href="https://review.coreboot.org/cgit/memtest86plus.git/">memtest86+ v5.0.1</a></li>
                </ul>
            </div>
        </div>
```

- replaces old example version `v4.9.0.7` with newer `v4.9.0.8` in above entry
- updates the links to binaries and signatures with newer version
- updates the comparison of source code between coreboot and payloads versions
- updates the current coreboot and payloads versions
- updates the release date in the entry
- removes the `<h2 class="text-middle">Mainline releases</h2>` from older entry
  and places it in new entry
- adds a break line after the newly added release `<div class="break"></div>`

> The script does not update the known issues and fixed/added sections

After the script done its work, fill the fixed/added sections with all
information from CHANGELOGs of coreboot, sortbootorder, SeaBIOS and other
repositories if applicable. At the end update the known issues if any new bugs
has been discovered and affect given releases. Each known issue should have a
tracking in GitHub issues and be linked to known issues in the `index.html` file
under affected versions.

3. Prepare a new blog post about new firmware release in the `_posts` directory.
   Such blog post should contain:

- a header in format:

```
---
layout: post
title:  "PC Engines apu coreboot Open Source Firmware v4.9.0.8"
date:   2019-08-10
categories: Firmware
---
# PC Engines apu coreboot Open Source Firmware v4.9.0.8

## Key changes
```

- little more verbose description of key changes in mainline and legacy releases
  (in separate ordered lists), based on the CHANGELOGs
- list of patches to upstream repositories divided into two sections: sent for
  review and merged by community
- the difference of recent tagged version of mainline to upstream coreboot master

Can be checked with:

```
git co vx.y.z.w
git diff --stat <commit_hash> ':(exclude).gitlab-ci.yml' ':(exclude)CHANGELOG.md'
```

Where the `<commit_hash>` is the short hash of the top commit on the master
branch of PC Engines coreboot fork at the time of checking out new release
branch (the rebase point).

- the testing section with the changes to validation suite and test statistics
  (filled by OSFV team)

- section with links to binaries and signatures of the new release

- section with comparison what has been planned for the new release and what has
  been done

Example [blog post](https://github.com/pcengines/pcengines.github.io/blob/master/_posts/2019-07-10-PC-Engines-Firmware-v4-9-0-7.md)

4. Commit the changes to the `rel_x.y.z.w` and setup a PR to `master`.
5. Prepare a mailchimp campaign based on the blog post in PR above (typically
   prepared by OSFV team or other person delegated).
6. If everything looks correct, merge the PR and schedule the mailchimp
   newsletter (typically done by a teamleader or other delegated person).
