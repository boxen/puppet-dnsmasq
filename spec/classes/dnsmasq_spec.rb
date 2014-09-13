require 'spec_helper'

describe 'dnsmasq' do

  let(:facts)       { default_test_facts }
  let(:boxen_home)  { "/test/boxen" }
  let(:configdir)   { "#{boxen_home}/config/dnsmasq" }
  let(:configfile)  { "#{configdir}/dnsmasq.conf" }
  let(:datadir)     { "#{boxen_home}/data/dnsmasq" }
  let(:logdir)      { "#{boxen_home}/log/dnsmasq" }
  let(:logfile)     { "#{logdir}/console.log" }
  let(:executable)  { "#{boxen_home}/homebrew/sbin/dnsmasq" }
  let(:tld)         { "dev" }
  let(:servicename) { "#{tld}.dnsmasq" }
  let(:params) {{
    'host'       => "127.0.0.1",
    'tld'        => tld,
    'configdir'  => configdir,
    'datadir'    => datadir,
    'logdir'     => logdir,
    'configfile' => configfile,
    'logfile'    => logfile,
    'executable' => executable,
  }}

  it do
    should include_class('homebrew')

    should contain_file(configdir).with_ensure('directory')
    should contain_file(datadir).with_ensure('directory')
    should contain_file(logdir).with_ensure('directory')

    should contain_file(configfile).with({
      :content => File.read('spec/fixtures/dnsmasq.conf'),
      :notify  => "Service[#{servicename}]",
      :require => "File[#{configdir}]",
    })

    should contain_file('/Library/LaunchDaemons/dev.dnsmasq.plist').with({
      :content => File.read('spec/fixtures/dev.dnsmasq.plist'),
      :group   => 'wheel',
      :notify  => "Service[#{servicename}]",
      :owner   => 'root',
    })

    should contain_file('/etc/resolver').with({
      :ensure => 'directory',
      :group  => 'wheel',
      :owner  => 'root',
    })

    should contain_file('/etc/resolver/dev').with({
      :content => 'nameserver 127.0.0.1',
      :group   => 'wheel',
      :owner   => 'root',
      :require => 'File[/etc/resolver]',
    })

    should contain_homebrew__formula('dnsmasq')

    should contain_package('boxen/brews/dnsmasq').with({
      :ensure => '2.71-boxen1',
      :notify => "Service[#{servicename}]",
    })

    should contain_service(servicename).with({
      :ensure  => 'running',
      :require => 'Package[boxen/brews/dnsmasq]',
    })
  end
end
