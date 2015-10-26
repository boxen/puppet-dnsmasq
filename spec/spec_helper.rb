require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
end

def default_test_facts
  @default_test_facts ||= {
    :boxen_home      => "/test/boxen",
    :boxen_user      => "testuser",
    :operatingsystem => "Debian",
    :osfamily        => "Debian",
    :ipaddress       => "127.0.0.1",
  }
end
