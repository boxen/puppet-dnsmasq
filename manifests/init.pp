# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq {
  require dnsmasq::config

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
