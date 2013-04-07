class dnsmasq::osx {
  include homebrew

  homebrew::formula { 'dnsmasq':
    before => Package['boxen/brews/dnsmasq'],
  }

  package { 'boxen/brews/dnsmasq':
    ensure => '2.57-boxen1',
    notify => Service['dev.dnsmasq']
  }

  file { '/Library/LaunchDaemons/dev.dnsmasq.plist':
    content => template('dnsmasq/osx/dev.dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.dnsmasq'],
    owner   => 'root'
  }
}
