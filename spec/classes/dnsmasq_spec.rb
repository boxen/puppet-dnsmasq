require "spec_helper"

describe "dnsmasq" do
  let(:facts) { default_test_facts }

  it do
    should include_class("homebrew")

    should contain_homebrew__formula("dnsmasq")

    should contain_file("/Library/LaunchDaemons/dev.dnsmasq.plist").with({
      :ensure => "present",
      :group  => "wheel",
      :owner  => "root",
      :notify => "Service[dnsmasq]",
    })

    should contain_file("/test/boxen/config/dnsmasq").with_ensure("directory")
    should contain_file("/test/boxen/log/dnsmasq").with_ensure("directory")

    should contain_file("/test/boxen/config/dnsmasq/dnsmasq.conf").with({
      :ensure => "present",
      :source => "puppet:///modules/dnsmasq/dnsmasq.conf",
      :notify => "Service[dnsmasq]",
    })

    should contain_file("/etc/resolver").with({
      :ensure => "directory",
      :group  => "wheel",
      :owner  => "root",
    })

    should contain_file("/etc/resolver/dev").with({
      :content => "nameserver 127.0.0.1",
      :group   => "wheel",
      :owner   => "root",
    })

    should contain_package("dnsmasq").with({
      :ensure => "2.57-boxen1",
      :name   => "boxen/brews/dnsmasq",
      :notify => "Service[dnsmasq]",
    })

    should contain_service("dnsmasq").with({
      :ensure  => "running",
      :enabled => true,
      :name    => "dev.dnsmasq",
      :require => "Package[dnsmasq]",
    })
  end

  context "Linux" do
    it do
      should_not include_class("homebrew")

      should_not contain_file("/Library/LaunchDaemons/dev.dnsmasq.plist")

      should_not contain_homebrew__formula("dnsmasq")
    end
  end
  
  context "ensure => absent" do
    let(:params) do
      {
        :ensure => "absent"
      }
    end
    
    it do
      should contain_file("/Library/LaunchDaemons/dev.dnsmasq.plist").with_ensure("absent")
      should contain_file("/test/boxen/config/dnsmasq").with_ensure("absent")
      should contain_file("/test/boxen/log/dnsmasq").with_ensure("absent")
      should contain_file("/test/boxen/config/dnsmasq/dnsmasq.conf").with_ensure("absent")
      should contain_file("/etc/resolver").with_ensure("absent")
      should contain_file("/etc/resolver/dev").with_ensure("absent")
      should contain_package("dnsmasq").with_ensure("absent")
      should contain_service("dnsmasq").with_ensure("stopped")
    end
  end
end
