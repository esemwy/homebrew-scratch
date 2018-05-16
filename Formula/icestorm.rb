class Icestorm < Formula
  desc ""
  homepage ""
  head "https://github.com/cliffordwolf/icestorm.git"

  depends_on "python3"
  depends_on "pkg-config"
  depends_on "libffi"
  depends_on "libusb"

  #patch :DATA

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "false"
  end
end

__END__
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
+++ b/iceprog/Makefile	2018-05-16 13:26:18.000000000 -0400
@@ -3,8 +3,15 @@
 ifneq ($(shell uname -s),Darwin)
   LDLIBS = -L/usr/local/lib -lm
 else
-  LIBFTDI_NAME = $(shell $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+  ifneq ($(shell which brew),)
+    LIBFTDI_NAME = $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+  else
+    LIBFTDI_NAME = $(shell $(PKG_CONFIG) --exists libftdi1 && echo ftdi1 || echo ftdi)
+  endif
   LDLIBS = -L/usr/local/lib -l$(LIBFTDI_NAME) -lm
+  echo $(LDLIBS)
+  echo $(LIBFTDI_NAME)
+  echo $(PKG_CONFIG_PATH)
 endif
 
 ifeq ($(STATIC),1)
@@ -12,8 +19,13 @@
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
