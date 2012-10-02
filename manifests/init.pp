class dnsmasq {
  require dnsmasq::config

  package { 'github/brews/dnsmasq':
    ensure => '2.57-github1',
    notify => Service['com.github.dnsmasq']
  }

  service { 'com.github.dnsmasq':
    ensure  => running,
    require => Package['github/brews/dnsmasq']
  }
}
