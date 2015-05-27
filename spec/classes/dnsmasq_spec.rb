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
      :notify  => "Service[#{servicename}]",
      :require => "File[#{configdir}]",
    }).with_content(%r{\naddress=/dev/127.0.0.1\nlisten-address=127.0.0.1\n})

    should contain_file('/Library/LaunchDaemons/dev.dnsmasq.plist').with({
      :group   => 'wheel',
      :notify  => "Service[#{servicename}]",
      :owner   => 'root',
    }).with_content(%r{<string>#{tld}.dnsmasq</string>})

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
      :ensure => '2.76-boxen2',
      :notify => "Service[#{servicename}]",
    })

    should contain_service(servicename).with({
      :ensure  => 'running',
      :require => 'Package[boxen/brews/dnsmasq]',
    })
  end

  context 'given a different tld' do
    let(:tld)         { "vagrant" }
    let(:servicename) { "dev.dnsmasq" }
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
 
      should contain_file(configfile).with({
        :notify  => "Service[#{servicename}]",
        :require => "File[#{configdir}]",
      }).with_content(%r{\naddress=/vagrant/127.0.0.1\nlisten-address=127.0.0.1\n})
 
      should contain_file('/Library/LaunchDaemons/dev.dnsmasq.plist').with({
        :group   => 'wheel',
        :notify  => "Service[#{servicename}]",
        :owner   => 'root',
      }).with_content(%r{<string>#{tld}.dnsmasq</string>})
 
      should contain_file('/etc/resolver/vagrant').with({
        :content => 'nameserver 127.0.0.1',
        :group   => 'wheel',
        :owner   => 'root',
        :require => 'File[/etc/resolver]',
      })
    end
  end
end
