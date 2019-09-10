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

include ../Makefile.defs

PROG =		cpp-$(ARCH)$(STRAP)
PROGDIR =	/usr/lib

OBJS = \
	cpp.$(ARCH).o$(STRAP) \
	y.tab.$(ARCH).o$(STRAP)

CLEANFILES += \
	y.tab.c$(STRAP)

#
# XXX We need to improve the bootstrap compiler selection. Right now GCC.HOST
# macros are assumign things that we can't use depending on the system that
# we're on.
#
ifeq ($(STRAP),strap)
GCC =		gcc
endif

CPPFLAGS +=	-Dunix
i86pc_CPPFLAGS += -DTARGET_I386
armv7a_CPPFLAGS += -DTARGET_ARM
armv8_CPPFLAGS += -DTARGET_ARMV8
riscv_CPPFLAGS += -DTARGET_RISCV
CFLAGS +=	-O2
LD =		$(GCC)

COMPILE.c =	$(GCC) $($(ARCH)_CPPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
LINK.prog =	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
PROTOFILES =	$(DESTDIR)$(PROGDIR)/$(PROG)

all: $(PROG)

install: $(PROTOFILES)

clean:
	-rm -f $(OBJS) $(CLEANFILES) $(PROG) *strap

$(PROG): $(OBJS)
	$(LINK.prog)

%.$(ARCH).o$(STRAP): %.c
	$(COMPILE.c)

#
# We need to distinguish between the cpp build in the bootstrap and the cpp
# built normally. However, when we install it, they need to have the same name.
# To handle this we add a small bit of shell logic. Note that the mv bit is
# explicitly ignored and instead we do a final check to make sure we have
# something called cpp at the very end which will either be because of install
# or because of the later mv.
#
$(DESTDIR)$(PROGDIR)/%: %
	mkdir -p $(DESTDIR)$(PROGDIR)
	/usr/sbin/install -m 0755 -f $(DESTDIR)$(PROGDIR) $(PROG)
	-[ "$(PROG)" == "cpp-$(ARCH)strap" ] && mv -f $(DESTDIR)$(PROGDIR)/$(PROG) \
	    $(DESTDIR)$(PROGDIR)/cpp
	[ -f "$(DESTDIR)$(PROGDIR)/cpp" ]

y.tab.c: cpy.y
	$(YACC) cpy.y
