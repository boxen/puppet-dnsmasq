# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq(
  $host       = undef,
  $tld        = undef,

  $configdir  = undef,
  $configfile = undef,
  $datadir    = undef,
  $executable = undef,
  $logdir     = undef,
  $logfile    = undef,
) {
  require homebrew
  $servicename = 'dev.dnsmasq'

  file { [$configdir, $logdir, $datadir]:
    ensure => directory,
  }

  file { "${configdir}/dnsmasq.conf":
    content => template('dnsmasq/dnsmasq.conf.erb'),
    notify  => Service[$servicename],
    require => File[$configdir],
  }

  file { "/Library/LaunchDaemons/${tld}.dnsmasq.plist":
    content => template("dnsmasq/${tld}.dnsmasq.plist.erb"),
    group   => 'wheel',
    notify  => Service[$servicename],
    owner   => 'root',
  }

  file { '/etc/resolver':
    ensure => directory,
    group  => 'wheel',
    owner  => 'root',
  }

  file { "/etc/resolver/${tld}":
    content => 'nameserver 127.0.0.1',
    group   => 'wheel',
    owner   => 'root',
    require => File['/etc/resolver'],
    notify  => Service[$servicename],
  }

  homebrew::formula { 'dnsmasq':
    before => Package['boxen/brews/dnsmasq'],
  }

  package { 'boxen/brews/dnsmasq':
    ensure => '2.71-boxen1',
    notify => Service[$servicename],
  }

  service { $servicename:
    ensure  => running,
    require => Package['boxen/brews/dnsmasq'],
  }

  service { 'com.boxen.dnsmasq': # replaced by dev.dnsmasq
    before => Service[$servicename],
    enable => false,
  }
}
