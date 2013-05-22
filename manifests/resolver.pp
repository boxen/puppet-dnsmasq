define dnsmasq::resolver(
  $nameserver,
  $ensure = present,
) {
  require dnsmasq
  
  validate_ipv4_address($nameserver)

  validate_re($ensure, '^(present|absent)$',
    "Dnsmasq::Resolver[${name}] ensure must be present|absent, is ${ensure}")
  
  file { "/etc/resolver/${name}":
    ensure  => $ensure,
    content => "nameserver ${nameserver}\n",
    group   => 'wheel',
    owner   => 'root',
  }
  
  if $::osfamily == 'Darwin' {
    file { "/Library/LaunchDaemons/${name}.dnsmasq.plist":
      ensure  => $file_ensure,
      content => template('dnsmasq/dnsmasq.plist.erb'),
      group   => 'wheel',
      owner   => 'root'
    }
  }
}
