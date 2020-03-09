#
# A 64-bit sqlite3 is required by the smatch build.  We build 32-bit too just in
# case it is required by other parts of the build.
#

VER =	sqlite-autoconf-3310100

include ../Makefile.defs

FETCH_URL.$(TARBALL) =	https://www.sqlite.org/2020/

#
# The installed headers are identical so there's no need for special handling.
#
AUTOCONF_OPTS.64 += \
	--bindir=$(AUTOCONF_PREFIX)/bin/amd64 \
	--libdir=$(AUTOCONF_PREFIX)/lib/amd64

BUILD64 =	yes

include ../Makefile.targ
include ../Makefile.targ.autoconf

