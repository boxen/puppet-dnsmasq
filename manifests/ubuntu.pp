class dnsmasq::ubuntu {
  package { 'dnsmasq':
    ensure => '2.59-4',
    notify => Service['dev.dnsmasq']
  }

  file { '/etc/init/dev.dnsmasq.conf':
    content => template('dnsmasq/ubuntu/dev.dnsmasq.conf.erb'),
    group   => 'root',
    notify  => Service['dev.dnsmasq'],
    owner   => 'root'
  }
}
