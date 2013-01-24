require 'spec_helper'

describe 'dnsmasq' do
  let(:boxen_home) { '/opt/boxen' }
  let(:logdir) { "#{boxen_home}/log" }
  let(:confdir) { "#{boxen_home}/config" }

  let(:facts) do
    {
      :boxen_home   => '/opt/boxen',
      :boxen_user   => 'testuser',
      :luser        => 'testuser',
      :boxen_srcdir => '/tmp/src',
      :github_login => 'testuser',
    }
  end

  it do
    should include_class('homebrew')
    should include_class('dnsmasq::config')

    should contain_file("#{confdir}/dnsmasq").with_ensure('directory')
    should contain_file("#{logdir}/dnsmasq").with_ensure('directory')

    should contain_file("#{confdir}/dnsmasq/dnsmasq.conf").with({
      :notify  => 'Service[dev.dnsmasq]',
      :require => "File[#{confdir}/dnsmasq]",
      :source  => 'puppet:///modules/dnsmasq/dnsmasq.conf',
    })

    should contain_file('/Library/LaunchDaemons/dev.dnsmasq.plist').with({
      :content => File.read('spec/fixtures/dev.dnsmasq.plist'),
      :group   => 'wheel',
      :notify  => 'Service[dev.dnsmasq]',
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
      :ensure => '2.57-boxen1',
      :notify => 'Service[dev.dnsmasq]',
    })

    should contain_service('dev.dnsmasq').with({
      :ensure  => 'running',
      :require => 'Package[boxen/brews/dnsmasq]',
    })
  end
end
