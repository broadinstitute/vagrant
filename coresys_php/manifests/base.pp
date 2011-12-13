exec { "apt-get update":
  command => "/usr/bin/apt-get update",
}

Package { require => Exec["apt-get update"] }
File { require => Exec["apt-get update"] }

package { "vim":
  ensure => present,
}

package { "apache2":
  ensure => present,
}

package { "php5":
  ensure => present,
}

package { "mysql-server":
  ensure => present,
}

package { "php5-mysql":
  ensure => present,
}

package { "php-pear":
  ensure => present,
}

package { "php5-xdebug":
  ensure => present,
}

service { "apache2":
  ensure => running,
  enable => true,
  subscribe => [File["/etc/apache2/mods-enabled/rewrite.load"], File["/etc/apache2/sites-available/default"]],
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

