exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}

Package { require => Exec["apt-get update"] }
File { require => Exec["apt-get update"] }

package { "postfix":
  ensure => present,
}

file { "/etc/postfix/main.cf":
  ensure => present,
  source => "/vagrant/manifests/main.cf",
  require => Package['postfix']
}

service { "postfix":
  ensure => running,
  enable => true,
  subscribe => File["/etc/postfix/main.cf"],
}

package { "vpnc":
  ensure => present,
}

package { "vim":
  ensure => present,
}

package { "mysql-server":
  ensure => present,
}

package { "php5":
  ensure => present,
}

package { "php5-xdebug":
  ensure => present,
}

package { "php5-mysql":
  ensure => present,
}

package { "php5-ldap":
  ensure => present,
}

package { "php-pear":
  ensure => present,
}

package { "php5-xsl":
  ensure => present
}

package { "php5-curl":
  ensure => present
}

file { "/etc/php5/apache2/php.ini":
  ensure => present,
  source => "/vagrant/manifests/php.ini",
}

exec {"/usr/bin/pear upgrade": }

exec { "/usr/bin/pear install PHP_Codesniffer":
  require => [Package['php-pear'], Exec['/usr/bin/pear upgrade']]
}

exec { "/usr/bin/pear config-set auto_discover 1":
  require => [Package['php-pear'], Exec['/usr/bin/pear upgrade']]
}

exec { "/usr/bin/pear install pear.phpunit.de/PHPUnit":
  require => [Package['php-pear'], Exec['/usr/bin/pear config-set auto_discover 1'], Exec['/usr/bin/pear upgrade']]
}

package { "apache2":
  ensure => present,
}

service { "apache2":
  ensure => running,
  enable => true,
  subscribe => [File["/etc/apache2/mods-enabled/rewrite.load"], File["/etc/apache2/sites-available/default"], File["/etc/php5/apache2/php.ini"]]
}

file { "/etc/apache2/mods-enabled/rewrite.load":
  ensure => link,
  target => "/etc/apache2/mods-available/rewrite.load",
  require => Package['apache2'],
}

file { "/etc/apache2/sites-available/default":
  ensure => present,
  source => "/vagrant/manifests/default",
}