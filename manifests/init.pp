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

  $servicename = "${tld}.dnsmasq"

  class { 'dnsmasq::config':
    configdir  => $configdir,
    configfile => $configfile,
    datadir    => $datadir,
    executable => $executable,
    logdir     => $logdir,
    logfile    => $logfile,
  }

  #require dnsmasq::config

  file { [$configdir, $logdir, $datadir]:
    ensure => directory
  }

  file { "${configdir}/dnsmasq.conf":
    content => template('dnsmasq/dnsmasq.conf.erb'),
    notify  => Service['dev.dnsmasq'],
    require => File[$configdir],
  }

  file { '/Library/LaunchDaemons/dev.dnsmasq.plist':
    content => template('dnsmasq/dev.dnsmasq.plist.erb'),
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
    content => "nameserver ${host}",
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
    notify => Service['dev.dnsmasq'],
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
