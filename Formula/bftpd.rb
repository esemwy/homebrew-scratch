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

    plist = etc/"bftpd.plist"
    unless plist.exist?
      plist.write <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>Disabled</key>
        	<false/>
        	<key>EnvironmentVariables</key>
        	<dict>
        		<key>PATH</key>
        		<string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin</string>
        	</dict>
        	<key>KeepAlive</key>
        	<dict>
        		<key>SuccessfulExit</key>
        		<true/>
        	</dict>
        	<key>Label</key>
        	<string>com.smy.bftpd</string>
        	<key>ProgramArguments</key>
        	<array>
        		<string>/usr/local/sbin/bftpd</string>
        		<string>-D</string>
        		<string>-c</string>
        		<string>/usr/local/etc/bftpd.conf</string>
        	</array>
        	<key>RunAtLoad</key>
        	<false/>
        </dict>
        </plist>
      EOS
    end
    chmod 0644, plist
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
            convert -geometry 1800x1200 "$ARGUMENT" -gravity SouthEast \\
                    -stroke '#000C' -strokewidth 2 -font "/Library/Fonts/Arial.ttf" -pointsize 15 -annotate 0 $ID \\
                    -stroke  none   -fill yellow -font "/Library/Fonts/Arial.ttf" -pointsize 15 -annotate 0 $ID "$OUTPUT"
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
