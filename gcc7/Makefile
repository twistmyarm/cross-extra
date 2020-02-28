#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright (c) 2018, Joyent, Inc.
#

VER =		gcc-7.4.0-il-1
MPFR_VER =	mpfr-3.1.6
GMP_VER =	gmp-6.1.2
MPC_VER =	mpc-1.0.3
NEWLIB_VER =	newlib-2.5.0.20171222
PREFIX =	/usr/gcc/7

include ../Makefile.defs

MPFR_TAR =	$(MPFR_VER).tar.bz2
GMP_TAR =	$(GMP_VER).tar.bz2
MPC_TAR =	$(MPC_VER).tar.gz
NEWLIB_TAR =	$(NEWLIB_VER).tar.gz

TARBALLS = $(TARBALL) $(MPFR_TAR) $(GMP_TAR) $(MPC_TAR) $(NEWLIB_TAR)

FETCH_URL.$(TARBALL) =		https://github.com/illumos/gcc/archive
FETCH_URL.$(MPFR_TAR) =		https://ftp.gnu.org/gnu/mpfr
FETCH_URL.$(GMP_TAR) =		https://ftp.gnu.org/gnu/gmp
FETCH_URL.$(MPC_TAR) =		https://ftp.gnu.org/gnu/mpc
FETCH_URL.$(NEWLIB_TAR) =	ftp://sourceware.org/pub/newlib

SEPARATE_BUILD =	yes

GCC =	/opt/local/bin/gcc
GXX =	/opt/local/bin/g++
CFLAGS = -g -O2

AUTOCONF_OPTS_i86pc = \
	--target=i386-pc-solaris2.11 \
	--enable-languages="c,c++" \
	--without-gnu-ld

AUTOCONF_OPTS_armv8 = \
	--target=aarch64-unknown-elf \
	--enable-languages="c" \
	--disable-libssp \
	--disable-libada \
	--disable-libgomp \
	--without-headers

AUTOCONF_OPTS_riscv = \
	--target=riscv64-unknown-elf \
	--enable-languages="c" \
	--disable-libssp \
	--disable-libada \
	--disable-libgomp \
	--without-headers

AUTOCONF_OPTS += \
	--with-gnu-as \
	--with-as=$(DESTDIR)/usr/gnu/bin/gas \
	--enable-shared \
	--disable-nls \
	--with-ld=/usr/bin/ld \
	--without-gnu-ld \
	--with-included-gettext \
	$(AUTOCONF_OPTS_$(ARCH))

AUTOCONF_ENV += \
	DESTDIR=$(DESTDIR) \
	MAKE=$(MAKE)

ifneq ($(ARCH),$(NATIVE_ARCH))
AUTOCONF_ENV += \
	AR_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gar \
	AS_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gas \
        NM_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gnm \
        LD_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gld \
        OBJDUMP_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gobjdump \
        OBJCOPY_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/gobjcopy \
        RANLIB_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/granlib \
	READELF_FOR_TARGET=$(DESTDIR)/usr/gnu/bin/readelf
endif


OVERRIDES += \
	$(AUTOCONF_CFLAGS) \
	STAGE1_CFLAGS="$(CFLAGS)" \
	CFLAGS_FOR_TARGET="$(CFLAGS)"

#
# Because we use a different build directory, we need to make sure we
# catch that when cleaning.
#
CLEANFILES += $(VER)-32.build $(VER)-32strap.build

#
# When building the strap code, it needs to exist in a different prefix.
#
ifeq ($(STRAP),strap)
AUTOCONF_PREFIX = $(PREFIX)
endif

#
# The runtime libraries that we build into proto.strap should be made to search
# for their dependencies there as well, so that programs built to run on the
# build machine (from proto.strap) find the correct copies of these libraries.
#
ifeq ($(STRAP),strap)
	STRAPFIX_LINKS= \
		$(DESTDIR)/$(PREFIX)/lib/64
	STRAPFIX_FILES_32 = \
		$(DESTDIR)/$(PREFIX)/lib/libgcc_s.so.1 \
		$(DESTDIR)/$(PREFIX)/lib/libstdc++.so.6
	STRAPFIX_FILES_64 = \
		$(DESTDIR)/$(PREFIX)/lib/64/libgcc_s.so.1 \
		$(DESTDIR)/$(PREFIX)/lib/64/libstdc++.so.6
	STRAPFIX_FILES = $(STRAPFIX_FILES_32) $(STRAPFIX_FILES_64)
endif

#
# Unlike everything else, gcc is built to be a cross-compiler, really.  It
# never runs on the target system, only the build system.  So it should not
# be using the proto area's headers or libraries.  Its own libraries will be
# built by the new compiler, and generally aren't using system headers anyway.
# This is not really completely true; for example, libstdc++.  This will
# need more work to be really right.  We only deliver the libraries.
#
AUTOCONF_CPPFLAGS =
AUTOCONF_LIBS =
GENLDFLAGS =

PATCHES =	Patches/*
#ALL_TGT =	bootstrap

include ../Makefile.targ
include ../Makefile.targ.autoconf

#
# We could use the mpfr and gmp from the build system (since the compiler will
# be run here), but there's no good way to make gcc build itself correctly if
# we do.  There are two main problems:
#
# 1. Stage2 and later cc1 and company don't honour any combination of LDFLAGS,
# LDFLAGS_FOR_TARGET, BOOT_LDFLAGS, STAGE2_LDFLAGS, etc.  The only ways to
# get these things built with -R/opt/local/lib are to use LD_OPTIONS, which will
# yield the wrong results for libraries, or to hack configure.
#
# 2. Even if we could get -R/opt/local/lib into these programs without building
# the libraries incorrectly, it would still be wrong.  The pkgsrc lib directory
# on many systems contains libgcc_s.so.1; however, cc1 was built by the stage2
# compiler and should find the libgcc that matches that compiler.  That happens
# to be the one we just built, not the pkgsrc one.
#
# Instead we have mpfr and gmp built as part of the gcc build itself.
#
#$(AUTOCONF_OUT.32): | $(VER.32)/mpfr $(VER.32)/gmp $(VER.32)/mpc $(VER.32)/newlib
$(AUTOCONF_OUT.32): | $(VER.32)/mpfr $(VER.32)/gmp $(VER.32)/mpc

$(VER.32)/newlib: $(NEWLIB_TAR) | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -z --no-same-owner -f $(NEWLIB_TAR)
	mv -f .unpack32/$(NEWLIB_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

$(VER.32)/mpfr: $(MPFR_TAR) | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -j --no-same-owner -f $(MPFR_TAR)
	mv -f .unpack32/$(MPFR_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

$(VER.32)/gmp: $(GMP_TAR) | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -j --no-same-owner -f $(GMP_TAR)
	mv -f .unpack32/$(GMP_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

$(VER.32)/mpc: $(MPC_TAR) | $(VER.32)
	-rm -rf $@
	mkdir -p .unpack32
	gtar x -C .unpack32 -z --no-same-owner -f $(MPC_TAR)
	mv -f .unpack32/$(MPC_VER) ./$@
	-rmdir .unpack32
	chmod 755 $@/configure
	touch $@/configure

.PHONY: strapfix
strapfix: $(STRAPFIX_LINKS) $(STRAPFIX_FILES) | install
	for f in $(STRAPFIX_FILES_32); do \
		/usr/bin/elfedit -e \
		    'dyn:runpath $(DESTDIR)/$(PREFIX)/lib' \
		    $$f; \
	done
	for f in $(STRAPFIX_FILES_64); do \
		/usr/bin/elfedit -e \
		    'dyn:runpath $(DESTDIR)/$(PREFIX)/lib/64' \
		    $$f; \
	done

$(STRAPFIX_LINKS):
	mkdir -p `dirname $@`
	[[ -h $@ ]] || ln -s amd64 $@
