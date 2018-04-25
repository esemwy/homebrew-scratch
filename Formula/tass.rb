# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tass < Formula
  desc ""
  homepage ""
  url "https://svwh.dl.sourceforge.net/project/tass64/source/64tass-1.53.1515-src.zip"
  sha256 "f18e5d3f7f27231c1f8ce781eee8b585fe5aaec186eccdbdb820c1b8c323eb6c"
  # depends_on "cmake" => :build

  patch :DATA

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    system "make"
    bin.install "64tass"
    man1.install "64tass.1"
  end

#  test do
#    asm = "test.asm"
#    unless asm.exist?
#      asm.write <<-EOS.undent
#        START	lda #$00
#        	ldx #$00
#        AGAIN	sta ($c0),y
#        	inx
#        	bne AGAIN
#        	rts
#    EOS
#    system "64tass", asm
#  end
end

__END__
diff -Naur a/Makefile b/Makefile
--- a/Makefile	2017-05-01 12:56:26.000000000 -0400
+++ b/Makefile	2018-04-25 12:49:50.000000000 -0400
@@ -8,7 +8,7 @@
 LDLIBS = -lm
 LANG = C
 REVISION := "1515?"
-CFLAGS = -O2 -DREVISION="\"$(REVISION)\""
+CFLAGS = -O2 -DREVISION="\"$(REVISION)\"" -D_XOPEN_SOURCE
 LDFLAGS =
 CFLAGS += $(LDFLAGS)
 TARGET = 64tass
