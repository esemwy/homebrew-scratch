class Icestorm < Formula
  desc ""
  homepage ""
  head "https://github.com/cliffordwolf/icestorm.git"

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "libffi"
  depends_on "libusb"

  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
    # mkdir -p /usr/local/share/icebox
    # mkdir -p /usr/local/bin
    # cp chipdb-384.txt    /usr/local/share/icebox/
    # cp chipdb-1k.txt     /usr/local/share/icebox/
    # cp chipdb-8k.txt     /usr/local/share/icebox/
    # cp chipdb-5k.txt     /usr/local/share/icebox/
    # cp chipdb-lm4k.txt   /usr/local/share/icebox/
    # cp icebox.py         /usr/local/bin/icebox.py
    # cp iceboxdb.py       /usr/local/bin/iceboxdb.py
    # cp icebox_chipdb.py  /usr/local/bin/icebox_chipdb
    # cp icebox_diff.py    /usr/local/bin/icebox_diff
    # cp icebox_explain.py /usr/local/bin/icebox_explain
    # cp icebox_asc2hlc.py /usr/local/bin/icebox_asc2hlc
    # cp icebox_hlc2asc.py /usr/local/bin/icebox_hlc2asc
    # cp icebox_colbuf.py  /usr/local/bin/icebox_colbuf
    # cp icebox_html.py    /usr/local/bin/icebox_html
    # cp icebox_maps.py    /usr/local/bin/icebox_maps
    # cp icebox_vlog.py    /usr/local/bin/icebox_vlog
    # cp icebox_stat.py    /usr/local/bin/icebox_stat
    # cp icepack /usr/local/bin/icepack
    # ln -sf icepack /usr/local/bin/iceunpack
    # cp iceprog /usr/local/bin/iceprog
    # cp icemulti /usr/local/bin/icemulti
    # cp icepll /usr/local/bin/icepll
    # cp icetime /usr/local/bin/icetime
    # cp icebram /usr/local/bin/icebram

  end

  test do
    system "false"
  end
end

__END__
diff -Naur a b
diff -Naur a/config.mk b/config.mk
--- a/config.mk	2018-05-16 10:13:34.000000000 -0400
+++ b/config.mk	2018-05-16 10:24:44.000000000 -0400
@@ -2,6 +2,10 @@
 
 CXX ?= clang++
 CC ?= clang
+ifneq ($(shell which brew),)
+BREW := $(shell brew --prefix)
+PKG_CONFIG_PATH += $(BREW)/lib/pkgconfig
+endif
 PKG_CONFIG ?= pkg-config
 
 C_STD ?= c99
diff -Naur a/iceprog/Makefile b/iceprog/Makefile
--- a/iceprog/Makefile	2018-05-16 10:13:34.000000000 -0400
+++ b/iceprog/Makefile	2018-05-16 13:05:11.000000000 -0400
@@ -3,7 +3,11 @@
 ifneq ($(shell uname -s),Darwin)
   LDLIBS = -L/usr/local/lib -lm
 else
-  LIBFTDI_NAME = $(shell $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+  ifneq ($(shell which brew),)
+    LIBFTDI_NAME = $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+  else
+    LIBFTDI_NAME = $(shell $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+    echo $(LIBFTDI_NAME)
+    echo $(PKG_CONFIG_PATH)
+  endif
   LDLIBS = -L/usr/local/lib -l$(LIBFTDI_NAME) -lm
 endif
 
@@ -12,8 +16,13 @@
 LDLIBS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --static --libs $$pkg && exit; done; echo -lftdi; )
 CFLAGS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --static --cflags $$pkg && exit; done; )
 else
-LDLIBS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --libs $$pkg && exit; done; echo -lftdi; )
-CFLAGS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --cflags $$pkg && exit; done; )
+  ifneq ($(shell which brew),)
+    LDLIBS += $(shell for pkg in libftdi1 libftdi; do PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --libs $$pkg && exit; done; echo -lftdi; )
+    CFLAGS += $(shell for pkg in libftdi1 libftdi; do PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --cflags $$pkg && exit; done; )
+  else
+    LDLIBS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --libs $$pkg && exit; done; echo -lftdi; )
+    CFLAGS += $(shell for pkg in libftdi1 libftdi; do $(PKG_CONFIG) --silence-errors --cflags $$pkg && exit; done; )
+  endif
 endif
 
 all: iceprog$(EXE)
