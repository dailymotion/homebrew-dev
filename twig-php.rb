require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class TwigPhp < Formula
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.6.1'
  md5 ''

  def install
    cd "ext/twig" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/twig.so'
    end
  end
end
