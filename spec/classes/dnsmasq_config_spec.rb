require 'spec_helper'

describe 'dnsmasq::config' do

  let(:facts) do
    {
      :boxen_home   => '/opt/boxen',
      :luser        => 'testuser',
      :boxen_srcdir => '/tmp/src',
      :github_login => 'testuser',
    }
  end

  it do
    should include_class('boxen::config')

    should contain_anchor('/opt/boxen/config/dnsmasq')
    should contain_anchor('/opt/boxen/config/dnsmasq/dnsmasq.conf')
    should contain_anchor('/opt/boxen/data/dnsmasq')
    should contain_anchor('/opt/boxen/homebrew/sbin/dnsmasq')
    should contain_anchor('/opt/boxen/log/dnsmasq')
    should contain_anchor('/opt/boxen/log/dnsmasq/console.log')
  end
end
