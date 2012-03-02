require 'formula'

def mysql_installed?
  `which mysql_config`.length > 0
end

def postgres_installed?
  `which pg_config`.length > 0
end

class Php < Formula
  url 'http://www.php.net/get/php-5.3.10.tar.bz2/from/this/mirror'
  homepage 'http://php.net/'
  md5 '816259e5ca7d0a7e943e56a3bb32b17f'
  version '5.3.10'

  devel do
    url 'http://downloads.php.net/stas/php-5.4.0RC8.tar.gz'
    md5 'b659032842fcb495c6203738f2cf5e38'
    version '5.4.0'
  end

  # So PHP extensions don't report missing symbols
  skip_clean ['bin', 'sbin']

  depends_on 'gettext'
  depends_on 'readline' unless ARGV.include? '--without-readline'
  depends_on 'libxml2'
  depends_on 'jpeg'
  depends_on 'mcrypt'
  depends_on 'gmp' if ARGV.include? '--with-gmp'

  depends_on 'libevent' if ARGV.include? '--with-fpm'
  depends_on 'freetds'if ARGV.include? '--with-mssql'
  depends_on 'icu4c' if ARGV.include? '--with-intl'

  if ARGV.include? '--with-mysql' and ARGV.include? '--with-mariadb'
    raise "Cannot specify more than one MySQL variant to build against."
  elsif ARGV.include? '--with-mysql'
    depends_on 'mysql' => :recommended unless mysql_installed?
  elsif ARGV.include? '--with-mariadb'
    depends_on 'mariadb' => :recommended unless mysql_installed?
  end

  if ARGV.include? '--with-pgsql'
    depends_on 'postgresql' => :recommended unless postgres_installed?
  end

  def options
   [
     ['--with-mysql', 'Include MySQL support'],
     ['--with-mariadb', 'Include MariaDB support'],
     ['--with-pgsql', 'Include PostgreSQL support'],
     ['--with-mssql', 'Include MSSQL-DB support'],
     ['--with-cgi', 'Enable building of the CGI executable (implies --without-apache)'],
     ['--with-fpm', 'Enable building of the fpm SAPI executable (implies --without-apache)'],
     ['--without-apache', 'Build without shared Apache 2.0 Handler module'],
     ['--with-intl', 'Include internationalization support'],
     ['--without-readline', 'Build without readline support'],
     ['--with-gmp', 'Include GMP support'],
     ['--with-suhosin', 'Include Suhosin patch']
   ]
  end

  def patches
    p = [DATA]
    p << "http://download.suhosin.org/suhosin-patch-5.3.9-0.9.10.patch.gz" if ARGV.include? '--with-suhosin'
    return p
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--with-config-file-path=#{etc}",
      "--with-config-file-scan-dir=#{etc}/php5/conf.d",
      "--with-iconv-dir=/usr",
      "--enable-dba",
      "--with-ndbm=/usr",
      "--enable-exif",
      "--enable-soap",
      "--enable-sqlite-utf8",
      "--enable-wddx",
      "--enable-ftp",
      "--enable-sockets",
      "--enable-zip",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-sysvmsg",
      "--enable-mbstring",
      "--enable-mbregex",
      "--enable-zend-multibyte",
      "--enable-bcmath",
      "--enable-calendar",
      "--with-openssl=/usr",
      "--with-zlib=/usr",
      "--with-bz2=/usr",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-iodbc",
      "--with-kerberos=/usr",
      "--with-libxml-dir=#{Formula.factory('libxml2').prefix}",
      "--with-xsl=/usr",
      "--with-curl=/usr",
      "--with-gd",
      "--enable-gd-native-ttf",
      "--with-freetype-dir=/usr/X11",
      "--with-mcrypt=#{Formula.factory('mcrypt').prefix}",
      "--with-jpeg-dir=#{Formula.factory('jpeg').prefix}",
      "--with-png-dir=/usr/X11",
      "--with-gettext=#{Formula.factory('gettext').prefix}",
      "--with-snmp=/usr",
      "--with-tidy",
      "--with-mhash",
      "--mandir=#{man}"
    ]

    args.push "--with-gmp" if ARGV.include? '--with-gmp'

    if ARGV.include? '--with-fpm' and ARGV.include? '--with-cgi'
      raise "Cannot specify more than one executable to build."
    elsif ARGV.include? '--with-fpm'
      args.push "--enable-fpm"
    elsif ARGV.include? '--with-cgi'
      args.push "--enable-cgi"
    end

    # Build Apache module by default
    unless ARGV.include? '--with-fpm' or ARGV.include? '--with-cgi' or ARGV.include? '--without-apache'
      args.push "--with-apxs2=/usr/sbin/apxs"
      args.push "--libexecdir=#{libexec}"
    end

    if ARGV.include? '--with-mysql' or ARGV.include? '--with-mariadb'
      args.push "--with-mysql-sock=/tmp/mysql.sock"
      args.push "--with-mysqli=mysqlnd"
      args.push "--with-mysql=mysqlnd"
      args.push "--with-pdo-mysql=mysqlnd"
    end

    if ARGV.include? '--with-pgsql'
      args.push "--with-pgsql=#{Formula.factory('postgresql').prefix}"
      args.push "--with-pdo-pgsql=#{Formula.factory('postgresql').prefix}"
    end

    if ARGV.include? '--with-mssql'
      args.push "--with-mssql=#{Formula.factory('freetds').prefix}"
    end

    if ARGV.include? '--with-intl'
      args.push "--enable-intl"
      args.push "--with-icu-dir=#{Formula.factory('icu4c').prefix}"
    end

    args.push "--with-readline=#{Formula.factory('readline').prefix}" unless ARGV.include? '--without-readline'

    system "./configure", *args

    unless ARGV.include? '--without-apache' or ARGV.include? '--with-cgi' or ARGV.include? '--with-fpm'
      # Use Homebrew prefix for the Apache libexec folder
      inreplace "Makefile",
        "INSTALL_IT = $(mkinstalldirs) '$(INSTALL_ROOT)/usr/libexec/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='$(INSTALL_ROOT)/usr/libexec/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so",
        "INSTALL_IT = $(mkinstalldirs) '#{libexec}/apache2' && $(mkinstalldirs) '$(INSTALL_ROOT)/private/etc/apache2' && /usr/sbin/apxs -S LIBEXECDIR='#{libexec}/apache2' -S SYSCONFDIR='$(INSTALL_ROOT)/private/etc/apache2' -i -a -n php5 libs/libphp5.so"
    end

    if ARGV.include? '--with-intl'
      inreplace 'Makefile' do |s|
        s.change_make_var! "EXTRA_LIBS", "\\1 -lstdc++"
      end
    end

    system "make"
    ENV.deparallelize # parallel install fails on some systems
    system "make install"

    etc.install "./php.ini-production" => "php.ini" unless File.exists? etc+"php.ini"
    chmod_R 0775, lib+"php"
    system bin+"pear", "config-set", "php_ini", etc+"php.ini"
  end

 def caveats; <<-EOS
For 10.5 and Apache:
    Apache needs to run in 32-bit mode. You can either force Apache to start
    in 32-bit mode or you can thin the Apache executable.

To enable PHP in Apache add the following to httpd.conf and restart Apache:
    LoadModule php5_module    #{libexec}/apache2/libphp5.so

The php.ini file can be found in:
    #{etc}/php.ini
   EOS
 end
end


__END__
diff -Naur php-5.3.2/ext/tidy/tidy.c php/ext/tidy/tidy.c 
--- php-5.3.2/ext/tidy/tidy.c	2010-02-12 04:36:40.000000000 +1100
+++ php/ext/tidy/tidy.c	2010-05-23 19:49:47.000000000 +1000
@@ -22,6 +22,8 @@
 #include "config.h"
 #endif
 
+#include "tidy.h"
+
 #include "php.h"
 #include "php_tidy.h"
 
@@ -31,7 +33,6 @@
 #include "ext/standard/info.h"
 #include "safe_mode.h"
 
-#include "tidy.h"
 #include "buffio.h"
 
 /* compatibility with older versions of libtidy */

--- a/ext/mssql/php_mssql.h	2010-12-31 21:19:59.000000000 -0500
+++ b/ext/mssql/php_mssql.h	2011-10-12 10:06:52.000000000 -0400
@@ -65,7 +65,6 @@
 #define dbfreelogin dbloginfree
 #endif
 #define dbrpcexec dbrpcsend
-typedef unsigned char	*LPBYTE;
 typedef float           DBFLT4;
 #else
 #define MSSQL_VERSION "7.0"
