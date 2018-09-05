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

#
# To build everything just run 'gmake' in this directory.
#

ARCHS =		i86pc armv8 riscv
NATIVE_ARCH =	$(shell uname -i)
ALT_ARCHS =	$(filter-out $(NATIVE_ARCH),$(ARCHS))
NATIVE_DESTDIR=	$(BASE_DESTDIR)/$(NATIVE_ARCH)

#
# At this point, we're always building boot strap.
#
STRAP=strap

#
# These directories are needed to exist on the host build system to be
# able to build and develop the system
#
# These need to be ordered in dep order for the time being.
#
NATIVE_HOST_SUBDIRS = \
	binutils \
	gcc7 \
	cpp

#
# These directories are what we need to build for the target system.
# These currently don't depend on anything in the host system.
#
# These need to be ordered in dep order for the time being.
#
NATIVE_TARGET_SUBDIRS= \
	binutils \
	gcc7 \
	cpp

all: strap

#
# We're doing this the max power way... XXX swap around native for ALT
# at some point.
#
strap.host:
	for d in $(NATIVE_TARGET_SUBDIRS); do \
		(cd $$d && \
		    STRAP=$(STRAP) \
		    PKG_CONFIG_LIBDIR="" \
		    NATIVE_ARCH=$(NATIVE_ARCH) \
		    ARCH=$(NATIVE_ARCH) \
		    $(MAKE) install); \
	done; \


strap: strap.host
	for arch in $(ALT_ARCHS) ; do \
		for d in $(NATIVE_TARGET_SUBDIRS); do \
			(cd $$d && \
			    STRAP=$(STRAP) \
			    PKG_CONFIG_LIBDIR="" \
			    NATIVE_ARCH=$(NATIVE_ARCH) \
			    ARCH=$$arch \
			    $(MAKE) install); \
		done; \
	done

.PHONY: strap world

#NATIVE_SUBDIRS= \
#	binutils \
#	gcc6 \
#	cpp \
#	libz \
#	make


