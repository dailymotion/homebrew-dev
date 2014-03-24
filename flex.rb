require 'formula'

class Flex < Formula
  url 'http://mir2.ovh.net/ftp.apache.org/dist/flex/4.12.0/binaries/apache-flex-sdk-4.12.0-bin.tar.gz'
  homepage 'http://flex.apache.org/download-binaries.html'
  sha1 '59dbd6c3d0baa8829e4c6101cd1166e85d2a3c0a'
  version 'v4.12.0'

  def install
    Dir['*'].each { |file| cp_r file, File.join( prefix, File.basename(file) ) }
  end


  def caveats;
    s= <<-EOS.undent
    To use the SDK you will need to:

    (a) add the bin folder to your $PATH:
      export PATH=$(brew --prefix flex)/bin:$PATH

    (b) set $FLEX_HOME:
      export FLEX_HOME=$(brew --prefix flex)

    (c) add the tasks jar to ANT:
      mkdir -p ~/.ant/lib
      ln -s $(brew --prefix flex)/ant/lib/flexTasks.jar ~/.ant/lib

    EOS
    s
  end
end
