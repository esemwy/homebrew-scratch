class Bftpd < Formula
  desc "Simple FTP server for UNIX"
  homepage "http://bftpd.sourceforge.net"
  url "http://tcpdiag.dl.sourceforge.net/project/bftpd/bftpd/bftpd-4.4/bftpd-4.4.tar.gz"
  sha256 "b805ebbdd3de993ca14d733ad9ad007ac342a1646b257d91a53ec87a36c7f741"

  # Patch to fix UTMPX dependency
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-pam", "--enable-debug"
    system "make"
    inreplace "bftpd.conf", 'PORT="21"', 'PORT="2021"'
    inreplace "bftpd.conf", 'DENY_LOGIN="Anonymous', '#DENY_LOGIN="Anonymous'
    inreplace "bftpd.conf", '/var', var
    inreplace "bftpd.conf", '/etc', etc
    inreplace "bftpd.conf", 'AUTH="PASSWD"', 'AUTH="PAM"'

    # make install has all the paths hardcoded; this is easier:
    sbin.install "bftpd"
    etc.install "bftpd.conf"
    man8.install "bftpd.8"

    script = bin/"post-stor-script.sh"
    unless script.exist?
      script.write <<-EOS.undent
        #!/bin/bash
        
        ARGUMENT=$1
        if [[ "$ARGUMENT" == *.JPG ]]
        then
            DIR=$(dirname "$ARGUMENT")
            BASE=$(basename "$ARGUMENT" .JPG)
            ID=${BASE:4}
            OUTPUT="${DIR}/HPC_${ID}.JPG"
            convert -geometry 1800x1200 "$ARGUMENT" -gravity SouthEast \
                -stroke '#000C' -strokewidth 2 -annotate 0 $ID \
                -stroke  none   -fill yellow -annotate 0 $ID "$OUTPUT"
            open "$OUTPUT"
        else
            echo "Ignoring '$ARGUMENT'"
        fi
      EOS
    end
    chmod 0755, script
  end
end

__END__
--- a/login.c	2014-09-29 15:00:10.000000000 -0400
+++ b/login.c	2015-12-04 13:28:00.000000000 -0500
@@ -151,7 +151,7 @@
         Will use timeval structure to get time instead.
         time(&(ut.ut_time));
         */
-#if !defined(__minix) && !defined(__NetBSD__)
+#if !defined(__minix) && !defined(__NetBSD__) && !defined(__APPLE__)
         gettimeofday(&tv, NULL);
         ut.ut_tv.tv_sec = tv.tv_sec;
         ut.ut_tv.tv_usec = tv.tv_usec;
