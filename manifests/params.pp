# Internal: Configure dnsmasq.

class dnsmasq::params {
  case $::osfamily {
    Darwin: {
      include boxen::config

      $configdir = "${boxen::config::configdir}/dnsmasq"
      $datadir   = "${boxen::config::datadir}/dnsmasq"
      $dnsmasq   = "${boxen::config::home}/homebrew/sbin/dnsmasq"
      $logdir    = "${boxen::config::logdir}/dnsmasq"
      $package   = 'boxen/brews/dnsmasq'
      $service   = 'dev.dnsmasq'
      $version   = '2.57-boxen1'
    }

    default: {
      $configdir = '/etc/dnsmasq'
      $datadir   = $configdir
      $dnsmasq   = '/usr/sbin/dnsmasq'
      $logdir    = '/var/log/dnsmasq'
      $package   = 'dnsmasq'
      $service   = 'dnsmasq'
      $version   = 'installed'
    }
  }
}
