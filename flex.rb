require 'formula'

class Flex < Formula
  url 'http://mir2.ovh.net/ftp.apache.org/dist/flex/4.12.1/binaries/apache-flex-sdk-4.12.1-bin.tar.gz'
  homepage 'http://flex.apache.org/download-binaries.html'
  sha1 '9d14529a607cd8260f4b37557f8989307fa5e7b9'
  version '4.12.1'

  option 'with-playerglobal', "Also installs playerglobal.swc"

  def install
    Dir['*'].each { |file| cp_r file, File.join( prefix, File.basename(file) ) }

    if build.with? 'playerglobal'
      (prefix/'framework/libs/player/13.0').mkpath
      resource("flash-playerglobal").fetch
      (prefix/'frameworks/libs/player/13.0').install resource("flash-playerglobal").cached_download => 'playerglobal.swc'

      inreplace (prefix/'frameworks/flex-config.xml') do |s|
        s.gsub! /<target-player>11.1<\/target-player>/, "<target-player>13.0</target-player>"
      end
    end
  end

  resource "flash-playerglobal" do
    url 'http://download.macromedia.com/get/flashplayer/updaters/13/playerglobal13_0.swc'
    version '13.0'
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
    if build.with? 'playerglobal'
      s += <<-EOS.undent
      (d) set $PLAYERGLOBAL_HOME:
        export PLAYERGLOBAL_HOME=$(brew --prefix flex)/frameworks/libs/player

      EOS
    end
    s
  end
end
