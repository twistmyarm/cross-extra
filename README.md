## Cross Building Setup

This repository has been tested to successfully produce armv8 and riscv
cross-compiled toolchains inside both an OmniOS pkgsrc zone, as well as
a regular SmartOS base image.

On a clean install of OmniOS r151032 you will need to first install some IPS
packages:

```bash
$ pkg install brand/pkgsrc system/header system/library/c-runtime
```

Next, follow the instructions at <https://omniosce.org/setup/zones> to
provision a pkgsrc zone.

Once running on either OS, you will need to install the following software
inside:

```bash
$ pkgin install flex gcc7 gmake gtar patch smartos-build-tools
```

On SmartOS you will also need the following packages in order to successfully
build the required illumos-gate components:

```bash
$ pkgin in p5-XML-Parser
```

Finally, you can build the toolchains by simply running `gmake` from within a
checkout of this repository.  You may want to set some custom variables, for
example:

```
$ gmake MAX_JOBS=8 WORKDIR=/var/tmp/build
```

By default `MAX_JOBS=128` and the work directories will be within the checked
out repository.

Afterwards you should end up with i386, armv8, and riscv toolchains under the
`proto/` directory.
