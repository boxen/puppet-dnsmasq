# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq(
  $host         = undef,
  $tld          = 'dev',
  $service_name = undef,
  $configdir    = undef,
  $configfile   = undef,
  $datadir      = undef,
  $executable   = undef,
  $logdir       = undef,
  $logfile      = undef,
) {
  require homebrew

  if ! $service_name {
    $service = "${tld}.dnsmasq"
  }

  file { [$configdir, $logdir, $datadir]:
    ensure => directory,
  }

  file { "${configdir}/dnsmasq.conf":
    content => template('dnsmasq/dnsmasq.conf.erb'),
    notify  => Service[$service],
    require => File[$configdir],
  }

  file { "/Library/LaunchDaemons/${service}.plist":
    content => template('dnsmasq/dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service[$service],
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
    notify  => Service[$service],
  }

  homebrew::formula { 'dnsmasq':
    before => Package['boxen/brews/dnsmasq'],
  }

  package { 'boxen/brews/dnsmasq':
    ensure => '2.76-boxen2',
    notify => Service[$service],
  }

  service { $service:
    ensure  => running,
    require => Package['boxen/brews/dnsmasq'],
  }

  service { 'com.boxen.dnsmasq': # replaced by dev.dnsmasq
    before => Service[$service],
    enable => false,
  }
}
