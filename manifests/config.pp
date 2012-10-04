# Internal: Configure dnsmasq.
#
# Examples
#
#   include dnsmasq::config
class dnsmasq::config {
  require boxen::config

  $configdir  = "${boxen::config::configdir}/dnsmasq"
  $configfile = "${configdir}/dnsmasq.conf"
  $datadir    = "${boxen::config::datadir}/dnsmasq"
  $executable = "${boxen::config::homebrewdir}/sbin/dnsmasq"
  $logdir     = "${boxen::config::logdir}/dnsmasq"
  $logfile    = "${logdir}/console.log"

  file { [$configdir, $logdir]:
    ensure => directory
  }

  file { "${configdir}/dnsmasq.conf":
    notify  => Service['com.boxen.dnsmasq'],
    require => File[$configdir],
    source  => 'puppet:///modules/dnsmasq/dnsmasq.conf'
  }

  file { '/Library/LaunchDaemons/com.boxen.dnsmasq.plist':
    content => template('dnsmasq/com.boxen.dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service['com.boxen.dnsmasq'],
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
