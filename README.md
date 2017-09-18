# Dnsmasq Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-dnsmasq.png)](https://travis-ci.org/boxen/puppet-dnsmasq)

Install the [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
local resolver. After this module is included the `.dev` domain will
consistently resolve to `127.0.0.1`.

## Usage

```puppet
include dnsmasq
```

### Using a domain other than .dev
If you wish to use something other than ```.dev``` you can set call your class with the following:

```puppet
class { 'dnsmasq': tld => 'docker' }
```

## Required Puppet Modules

* `boxen`
* `homebrew`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
