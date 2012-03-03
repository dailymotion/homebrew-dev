require 'formula'

class Flex < Formula
  url 'https://github.com/downloads/dailymotion/homebrew/flex_4.5.0.19786.zip'
  homepage 'http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK'
  md5 'a59a289a2c98c9b5d1749d38fef02abc'

  def install
    libexec.install Dir['*']
  end

  def caveats; <<-EOS.undent
    To use the SDK you will need to:

    (a) add the bin folder to your $PATH:
      #{libexec}/bin

    (b) set $FLEX_HOME:
      export FLEX_HOME=#{libexec}

    (c) add the tasks jar to ANT:
      mkdir -p ~/.ant/lib
      ln -s #{libexec}/ant/lib/flexTasks.jar ~/.ant/lib
    EOS
  end
end
