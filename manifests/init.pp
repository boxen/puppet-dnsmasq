class dnsmasq {
  require dnsmasq::config

  package { 'boxen/brews/dnsmasq':
    ensure => '2.57-boxen1',
    notify => Service['com.boxen.dnsmasq']
  }

  service { 'com.boxen.dnsmasq':
    ensure  => running,
    require => Package['boxen/brews/dnsmasq']
  }
}
