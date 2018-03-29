# fmw_rcu

#### Table of Contents

1. [Overview - What is the fmw_rcu module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_rcu](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: common](#manifest-common)
        * [Manifest: soa_suite](#manifest-soa_suite)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_rcu module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_rcu module allows you to create or drop a FMW repository on a 11g or 12c Oracle Database.

## Module description

This modules allows you to create a 11g, 11gR2 or 12c FMW soa suite, webcenter or OIM/OAM repository on any 11.2.0.4 or 12c Oracle Database.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

--

#### Manifest soa_suite

This will create or drop a FMW SOA Suite repository

Used Defaults

    class fmw_rcu::params()
    {
      $version       = '12.1.3' # 10.3.6|12.1.1|12.1.2|12.1.3|12.2.1|12.2.1.1|12.2.1.2

      $os_user       = 'oracle'
      $os_group      = 'oinstall'

      $db_sys_user   = 'sys'
      $rcu_prefix    = 'DEV1'

      $middleware_home_dir = $::kernel? {
        'windows' => 'C:/oracle/middleware',
        default   => '/opt/oracle/middleware',
      }

      $tmp_dir = $::kernel? {
        'windows' => 'C:/temp',
        default   => '/tmp',
      }
    }


On Linux, this requires fmw_inst::soa_suite

    class {'fmw_rcu::soa_suite':
      version                => '12.1.3',
      java_home_dir          => '/usr/java/jdk1.7.0_75',
      middleware_home_dir    => '/opt/oracle/middleware',
      oracle_home_dir        => '/opt/oracle/middleware/oracle_common',
      rcu_prefix             => 'DEV1',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

or for WebLogic 10.3.6, this requires fmw_wls::install

    class {'fmw_rcu::soa_suite':
      version                => '10.3.6',
      java_home_dir          => '/usr/java/jdk1.7.0_75',
      source_file            => '/software/ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip',
      rcu_prefix             => 'DEV2',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

On Windows, this requires fmw_inst::soa_suite

    class {'fmw_rcu::soa_suite':
      version                => '12.1.3',
      java_home_dir          => 'c:\\java\\jdk1.7.0_75'
      middleware_home_dir    => 'C:\\Oracle\\middleware_1213',
      oracle_home_dir        => 'C:\\Oracle\\middleware_1213\\oracle_common',
      rcu_prefix             => 'DEV3',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

or for WebLogic 10.3.6, this requires fmw_wls::install

    class {'fmw_rcu::soa_suite':
      version                => '10.3.6',
      java_home_dir          => 'c:\\java\\jdk1.7.0_75'
      middleware_home_dir    => 'C:\\Oracle\\middleware_1036',
      source_file            => 'c:\\software\\ofm_rcu_win_11.1.1.7.0_32_disk1_1of1.zip',
      rcu_prefix             => 'DEV2',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

#### Manifest common

This will create or drop a FMW repository for a basic Fusion middleware domain with OPSS, UMS etc

Requires the fmw_wls::install recipe

On Linux

    class {'fmw_rcu::common':
      version                => '12.1.3',
      java_home_dir          => '/usr/java/jdk1.7.0_75',
      middleware_home_dir    => '/opt/oracle/middleware',
      oracle_home_dir        => '/opt/oracle/middleware/oracle_common',
      rcu_prefix             => 'DEV1',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

or for WebLogic 10.3.6

    class {'fmw_rcu::common':
      version                => '10.3.6',
      java_home_dir          => '/usr/java/jdk1.7.0_75',
      source_file            => '/software/ofm_rcu_linux_11.1.1.7.0_64_disk1_1of1.zip',
      rcu_prefix             => 'DEV2',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }



## Limitations

This should work on Windows, Linux (Any RedHat or Debian platform family distribution)

## Development

### Contributing

Community contributions are essential for keeping them great. We want to keep it as easy as possible to contribute changes so that our cookbooks work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

### Running-tests

This project contains tests for puppet-lint, puppet-syntax, puppet-rspec, rubocop and beaker. For in-depth information please see their respective documentation.

Quickstart:

    yum install -y ruby-devel gcc zlib-devel libxml2 libxslt
    yum install -y libxml2-devel libxslt-devel
    gem install bundler --no-rdoc --no-ri
    bundle install --without development

    bundle exec rake syntax
    bundle exec rake lint
    # symbolic error under windows , https://github.com/mitchellh/vagrant/issues/713#issuecomment-13201507. start vagrant in admin cmd session
    bundle exec rake spec
    bundle exec rubocop

    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=centos-70-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance

    set SOFTWARE_FOLDER=c:/software
    set BEAKER_destroy=onpass
    set BEAKER_debug=true
    set BEAKER_set=debian-78-x64
    bundle exec rspec spec/acceptance

    bundle exec rake yard

    # Ruby on Windows
    use only 32-bits, its more stable, http://rubyinstaller.org/downloads/

    Ruby 2.0.0-p598 to C:\Ruby\200
    Ruby Development kit to C:\Ruby\2_devkit, so you can optionally build your gems

    set PATH=%PATH%;C:\Ruby\200\bin
    C:\Ruby\2_devkit\devkitvars.bat
    ruby -v