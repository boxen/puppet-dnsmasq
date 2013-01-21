require 'spec_helper'

describe 'dnsmasq' do
  let(:facts) do
    {
      :boxen_home   => '/opt/boxen',
      :luser        => 'testuser',
      :boxen_srcdir => '/tmp/src',
      :github_login => 'testuser',
    }
  end

  it { should include_class('dnsmasq::config') }

  it do
    should contain_package('boxen/brews/dnsmasq').with({
      :ensure => '2.57-boxen1',
      :notify => 'Service[dev.dnsmasq]',
    })
  end

  it do
    should contain_service('dev.dnsmasq').with({
      :ensure  => 'running',
      :require => 'Package[boxen/brews/dnsmasq]',
    })
  end
end
