class dnsmasq::config {
  require github::config

  $configdir  = "${github::config::configdir}/dnsmasq"
  $configfile = "${configdir}/dnsmasq.conf"
  $datadir    = "${github::config::datadir}/dnsmasq"
  $executable = "${github::config::homebrewdir}/sbin/dnsmasq"
  $logdir     = "${github::config::logdir}/dnsmasq"
  $logfile    = "${logdir}/console.log"

  file { [$configdir, $logdir]:
    ensure => directory
  }

  file { "${configdir}/dnsmasq.conf":
    notify  => Service['com.github.dnsmasq'],
    require => File[$configdir],
    source  => 'puppet:///modules/dnsmasq/dnsmasq.conf'
  }

  file { '/Library/LaunchDaemons/com.github.dnsmasq.plist':
    content => template('dnsmasq/com.github.dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.github.dnsmasq'],
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
    require => File['/etc/resolver']
  }
}
