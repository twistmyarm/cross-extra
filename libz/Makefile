#
# A 32-bit libz is required for mandoc, but build 64-bit anyway in case it is
# used by others.
#

VER =	zlib-1.2.3

include ../Makefile.defs

FETCH_URL.$(TARBALL) =	https://www.zlib.net/fossils/

AUTOCONF_OPTS += \
	--shared

AUTOCONF_CFLAGS =
AUTOCONF_CFLAGS.64 =
AUTOCONF_LDFLAGS =
AUTOCONF_LDFLAGS.64 =

BUILD64 =	yes

include ../Makefile.targ
include ../Makefile.targ.autoconf

install_autoconf_32: all
	mkdir -p $(DESTDIR)/usr/lib $(DESTDIR)/usr/include
	(cd $(OBJ.32); \
	    cp zlib.h zconf.h $(DESTDIR)/usr/include; \
	    chmod 644 $(DESTDIR)/usr/include/zlib.h; \
	    chmod 644 $(DESTDIR)/usr/include/zconf.h; \
	    cp libz.so.1.2.3 $(DESTDIR)/usr/lib; \
	    cd $(DESTDIR)/usr/lib; \
	    rm -f libz.so libz.so.1; \
	    ln -s libz.so.1.2.3 libz.so; \
	    ln -s libz.so.1.2.3 libz.so.1)

install_autoconf_64: all
	mkdir -p $(DESTDIR)/usr/lib/amd64
	(cd $(OBJ.64); \
	    cp libz.so.1.2.3 $(DESTDIR)/usr/lib/amd64; \
	    cd $(DESTDIR)/usr/lib/amd64; \
	    rm -f libz.so libz.so.1; \
	    ln -s libz.so.1.2.3 libz.so; \
	    ln -s libz.so.1.2.3 libz.so.1)
