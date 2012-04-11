require 'formula'

class Libhsclient < Formula
  homepage 'https://github.com/dailymotion/chash'
  url 'https://github.com/DeNADev/HandlerSocket-Plugin-for-MySQL/tarball/1.1.0'
  md5 '2865bc609df77209272fb7a7be80284a'

  depends_on "libtool"
  depends_on "automake"
  depends_on "autoconf"

  def install
    ENV["LIBTOOLIZE"] = "glibtoolize"
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-handlersocket-server"
    system "make install"
  end
end
