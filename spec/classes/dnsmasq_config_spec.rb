require 'spec_helper'

describe 'dnsmasq::config' do
  let(:boxen_home) { '/opt/boxen' }
  let(:logdir) { "#{boxen_home}/log" }
  let(:confdir) { "#{boxen_home}/config" }
  let(:facts) do
    {
      :boxen_home   => '/opt/boxen',
      :luser        => 'testuser',
      :boxen_srcdir => '/tmp/src',
      :github_login => 'testuser',
    }
  end

  it { should include_class('boxen::config') }
  it { should contain_file("#{confdir}/dnsmasq").with_ensure('directory') }
  it { should contain_file("#{logdir}/dnsmasq").with_ensure('directory') }

  it do
    should contain_file("#{confdir}/dnsmasq/dnsmasq.conf").with({
      :notify  => 'Service[com.boxen.dnsmasq]',
      :require => "File[#{confdir}/dnsmasq]",
      :source  => 'puppet:///modules/dnsmasq/dnsmasq.conf',
    })
  end

  it do
    should contain_file('/Library/LaunchDaemons/com.boxen.dnsmasq.plist').with({
      :content => File.read('spec/fixtures/com.boxen.dnsmasq.plist'),
      :group   => 'wheel',
      :notify  => 'Service[com.boxen.dnsmasq]',
      :owner   => 'root',
    })
  end

  it do
    should contain_file('/etc/resolver').with({
      :ensure => 'directory',
      :group  => 'wheel',
      :owner  => 'root',
    })
  end

  it do
    should contain_file('/etc/resolver/dev').with({
      :content => 'nameserver 127.0.0.1',
      :group   => 'wheel',
      :owner   => 'root',
      :require => 'File[/etc/resolver]',
    })
  end
end
