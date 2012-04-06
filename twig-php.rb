require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class TwigPhp < Formula
  homepage 'http://twig.sensiolabs.org/'
  url 'https://github.com/fabpot/Twig/tarball/v1.6.4'
  md5 '78d4c7085b4eff23472821db5e897820'

  def install
    cd "ext/twig" do
      system "phpize"
      system "./configure", "--prefix=#{prefix}"
      system "make"
      prefix.install 'modules/twig.so'
    end
  end
end
