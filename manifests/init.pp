# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq {
  require homebrew
  require dnsmasq::config

  file { [$dnsmasq::config::configdir, $dnsmasq::config::logdir]:
    ensure => directory
  }

  file { "${dnsmasq::config::configdir}/dnsmasq.conf":
    notify  => Service['dev.dnsmasq'],
    require => File[$dnsmasq::config::configdir],
    source  => 'puppet:///modules/dnsmasq/dnsmasq.conf'
  }

  file { '/Library/LaunchDaemons/dev.dnsmasq.plist':
    content => template('dnsmasq/dev.dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.dnsmasq'],
    owner   => 'root'
  }

  file { '/etc/resolver':
    ensure => directory,
    group  => 'wheel',
    owner  => 'root'
  }

  file { '/etc/resolver/dev':
    content => 'nameserver 127.0.0.1',
    group   => 'wheel',
    owner   => 'root',
    require => File['/etc/resolver'],
    notify  => Service['dev.dnsmasq'],
  }

  homebrew::formula { 'dnsmasq':
    before => Package['boxen/brews/dnsmasq'],
  }

  package { 'boxen/brews/dnsmasq':
    ensure => '2.57-boxen1',
    notify => Service['dev.dnsmasq']
  }

  service { 'dev.dnsmasq':
    ensure  => running,
    require => Package['boxen/brews/dnsmasq']
  }

  service { 'com.boxen.dnsmasq': # replaced by dev.dnsmasq
    before => Service['dev.dnsmasq'],
    enable => false
  }
}
