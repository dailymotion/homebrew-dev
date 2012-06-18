require 'formula'

class Libhsclient < Formula
  homepage 'https://github.com/dailymotion/chash'
  url 'https://github.com/DeNADev/HandlerSocket-Plugin-for-MySQL/tarball/1.1.0'
  md5 '2865bc609df77209272fb7a7be80284a'

  depends_on "libtool"
  depends_on "automake"
  depends_on "autoconf"

  def patches
    return [DATA]
  end

  def install
    ENV["LIBTOOLIZE"] = "glibtoolize"
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-handlersocket-server"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 202f539..1db2ae7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@
 #AC_PREREQ([2.63b])
 AC_INIT([handlersocket-plugin], [1.0.6], [https://github.com/ahiguti/HandlerSocket-Plugin-for-MySQL
 AC_CONFIG_HEADERS([config.h])
-AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AM_INIT_AUTOMAKE([-Wall -Wno-extra-portability -Werror foreign])
 AC_CONFIG_SRCDIR([libhsclient/fatal.cpp])
 AC_CONFIG_MACRO_DIR([m4])
