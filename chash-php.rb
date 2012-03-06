require 'formula'

class ChashPhp < Formula
  homepage 'https://github.com/dailymotion/chash'
  url 'https://github.com/dailymotion/chash/tarball/1.0.1'
  md5 '24eb0e3748d50b3d62efd6841703ccb7'

  depends_on "libtool"
  depends_on "automake"
  depends_on "pkg-config"
  depends_on "libchash"

  def install
    cd "php" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/chash.so'
    end
  end
end
