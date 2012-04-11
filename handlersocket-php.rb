require 'formula'

class HandlersocketPhp < Formula
  homepage 'http://code.google.com/p/php-handlersocket/'
  url 'http://php-handlersocket.googlecode.com/files/php-handelrsocket-0.3.1.tar.gz'
  md5 '87689883a01fd9bc8b0467c0bd96cf6a'

  depends_on 'libhsclient'

  def install
    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
