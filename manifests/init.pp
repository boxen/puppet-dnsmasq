# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq(
  $ensure    = present,

  $configdir = $dnsmasq::params::configdir,
  $datadir   = $dnsmasq::params::datadir,
  $dnsmasq   = $dnsmasq::params::dnsmasq,
  $logdir    = $dnsmasq::params::logdir,
  $package   = $dnsmasq::params::package,
  $service   = $dnsmasq::params::service,
  $version   = $dnsmasq::params::version,
) inherits dnsmasq::params {

  validate_re($ensure, '^(present|absent)$',
    "Dnsmasq[${name}] ensure must be present|absent, is ${ensure}")

  if $ensure == absent {
    $dir_ensure  = absent
    $file_ensure = absent
    $pkg_ensure  = absent
    $svc_ensure  = stopped
    $svc_enable  = false
    
    File {
      require => Package['dnsmasq']
    }
    
    Package {
      require => Service['dnsmasq']
    }
  } else {
    $dir_ensure  = directory
    $file_ensure = present
    $pkg_ensure  = $version
    $svc_ensure  = running
    $svc_enable  = true
    
    File {
      before => Package['dnsmasq'],
      notify => Service['dnsmasq'],
    }
    
    Package {
      notify => Service['dnsmasq']
    }
  }

  $configfile = "${configdir}/dnsmasq.conf"
  $logfile    = "${logdir}/console.log"

  case $::osfamily {
    Darwin: {
      include homebrew

      homebrew::formula { 'dnsmasq':
        before => Package['dnsmasq'],
      }
    }
    
    default: {
      #noop
    }
  }

  file {
    [$configdir, $logdir]:
      ensure => $dir_ensure ;
    $configfile:
      ensure => $file_ensure,
      source => 'puppet:///modules/dnsmasq/dnsmasq.conf' ;
    '/etc/resolver':
      ensure => $dir_ensure,
      group  => 'wheel',
      owner  => 'root' ;
  }

  package { 'dnsmasq':
    ensure => $pkg_ensure,
    name   => $package,
  }

  service { 'dnsmasq':
    ensure => $svc_ensure,
    name   => $service,
    enable => $svc_enable,
  }
  
  dnsmasq::resolver { 'dev':
    ensure     => $file_ensure,
    nameserver => '127.0.0.1'
  }
}
