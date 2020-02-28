## Cross Building Setup

This repository has been tested to successfully produce armv8 and riscv
cross-compiled toolchains inside an OmniOS pkgsrc zone.

On a clean install of OmniOS r151032 you will need to first install some IPS
packages:

```bash
$ pkg install brand/pkgsrc system/header system/library/c-runtime
```

Next, follow the instructions at <https://omniosce.org/setup/zones> to
provision a pkgsrc zone.  Once running, you will need to install the following
software inside:

```bash
$ pkgin install byacc flex gcc7 gmake gtar patch
```

Finally, you can build the toolchains by simply running `gmake` from within a
checkout of this repository.  You may want to set some custom variables, for
example:

```
$ gmake MAX_JOBS=8 WORKDIR=/var/tmp/build
```

By default `MAX_JOBS=128` and the work directories will be within the checked
out repository.
