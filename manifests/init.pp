# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq

class dnsmasq {
  include dnsmasq::config

  case $::operatingsystem {
    Darwin: { include dnsmasq::osx }
    Ubuntu: { include dnsmasq::ubuntu }

    default: { fail("Unsupported operating system: ${::operatingsystem}!") }
  }

  file {
    [$dnsmasq::config::configdir, $dnsmasq::config::logdir]:
      ensure => directory ;
    '/etc/resolver':
      ensure => directory,
      group  => 'wheel',
      owner  => 'root' ;
    '/etc/resolver/dev':
      content => 'nameserver 127.0.0.1',
      group   => 'wheel',
      owner   => 'root',
      notify  => Service['dev.dnsmasq'] ;
    "${dnsmasq::config::configdir}/dnsmasq.conf":
      notify  => Service['dev.dnsmasq'],
      source  => 'puppet:///modules/dnsmasq/dnsmasq.conf' ;
  }

  service {
    'dev.dnsmasq':
      ensure => running
      alias  => 'dnsmasq',
      enable => true ;
    'com.boxen.dnsmasq':
      before => Service['dev.dnsmasq'],
      enable => false ;
  }
}
