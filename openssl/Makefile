#
# 64-bit OpenSSL libraries are required by smatch.
#

VER =	openssl-1.1.1d

include ../Makefile.defs

FETCH_URL.$(TARBALL) =	https://www.openssl.org/source/

BUILD64 =	yes

AUTOCONF_OPTS.32 += \
	solaris-x86-gcc

AUTOCONF_OPTS.64 += \
	--libdir=$(AUTOCONF_PREFIX)/lib/amd64 \
	solaris64-x86_64-gcc

UNPACK_SENTINEL =	Configure

INSTALL_TGT =	install_dev

include ../Makefile.targ
include ../Makefile.targ.autoconf
