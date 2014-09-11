# Internal: Configure dnsmasq.
#
# Examples
#
#   include dnsmasq::config
class dnsmasq::config(
  $configdir  = undef,
  $configfile = undef,
  $datadir    = undef,
  $executable = undef,
  $logdir     = undef,
  $logfile    = undef,
) {
  anchor { [
    $configdir,
    $configfile,
    $datadir,
    $executable,
    $logdir,
    $logfile,
  ]: }
}
