require 'formula'

class Libchash < Formula
  homepage 'https://github.com/dailymotion/chash'
  url 'https://github.com/dailymotion/chash/tarball/1.0.1'
  md5 '24eb0e3748d50b3d62efd6841703ccb7'

  depends_on "libtool"
  depends_on "automake"
  depends_on "pkg-config"

  def install
    cd "libchash" do
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./bootstrap.sh"
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end

    cd "php" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/chash.so'
    end
  end
end
