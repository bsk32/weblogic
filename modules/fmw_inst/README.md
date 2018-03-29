# fmw_inst

#### Table of Contents

1. [Overview - What is the fmw_inst module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_inst](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: soa_suite](#manifest-soa_suite)
        * [Manifest: service_bus](#manifest-service_bus)
        * [Manifest: soa_suite](#manifest-soa_suite)
        * [Manifest: mft](#manifest-mft)
        * [Manifest: oim](#manifest-oim)
        * [Manifest: jrf](#manifest-jrf)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_inst module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_inst module allows you to install any 11g or 12c Oracle Fusion Middleware software on a WebLogic 11g or 12c middleware environment.

## Module description

This modules allows you to install any FMW (10.3.6) or 12c (12.1, 12.2) products like SOA Suite, Service Bus, IDM.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

This is an manifest for overriding the defaults

    class { 'fmw_inst':
      version             => '12.1.3',
      middleware_home_dir => '/opt/oracle/middleware',
      orainst_dir         => '/etc',
      os_user             => 'oracle',
      os_group            => 'oinstall',
      tmp_dir             => '/tmp',
    }

with all the defaults

    class fmw_inst::params()
    {
      $version       = '12.1.3' # 10.3.6|12.1.1|12.1.2|12.1.3|12.2.1

      $os_user       = 'oracle'
      $os_group      = 'oinstall'

      $middleware_home_dir = $::kernel? {
        'windows' => 'C:/oracle/middleware',
        default   => '/opt/oracle/middleware',
      }

      $tmp_dir = $::kernel? {
        'windows' => 'C:/temp',
        default   => '/tmp',
      }

      $orainst_dir = $::kernel? {
        'SunOS' => '/var/opt/oracle',
        default => '/etc',
      }

    }

#### Manifest soa_suite

    class { 'fmw_inst':
      version             => '12.1.3',  # this is also the default
      middleware_home_dir => '/opt/oracle/middleware', # this is the default for linux and solaris
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      java_home_dir => '/usr/java/jdk1.7.0_75',
      source_file   => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
    }

    or

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version => '10.3.6',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      java_home_dir => '/usr/java/jdk1.7.0_75',
      source_file   => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
      source_2_file => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
    }

In hiera

    ---

    # executed manifest classes
    classes:
      - fmw_jdk::rng_service
      - fmw_jdk::install
      - fmw_wls::setup
      - fmw_wls::install
      - fmw_inst::soa_suite

    # general variables
    java_home_dir:             &java_home_dir       '/usr/java/jdk1.7.0_75'
    version:                   &version             '12.1.3'
    middleware_home_dir:       &middleware_home_dir '/opt/oracle/middleware'

    # class parameters
    fmw_jdk::install::java_home_dir: *java_home_dir
    fmw_jdk::install::source_file:   '/software/jdk-7u75-linux-x64.tar.gz'

    fmw_wls::version:                *version                 # this is also the default
    fmw_wls::middleware_home_dir:    *middleware_home_dir     # this is the default for linux and solaris
    fmw_wls::install::java_home_dir: *java_home_dir
    fmw_wls::install::source_file:   '/software/fmw_12.1.3.0.0_infrastructure.jar'
    fmw_wls::install::install_type:  'infra'                  # 'wls' is the default

    fmw_inst::version:                    *version                # this is also the default
    fmw_inst::middleware_home_dir:        *middleware_home_dir    # this is the default for linux and solaris
    fmw_inst::soa_suite::java_home_dir:   *java_home_dir
    fmw_inst::soa_suite::source_file:     '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip'

Windows

    class { 'fmw_inst':
      version             => 'c:\\java\\jdk1.7.0_75',
      middleware_home_dir => 'C:\\Oracle\\middleware_1213',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      java_home_dir => 'c:\\java\\jdk1.7.0_75',
      source_file   => 'c:\\software\\fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
    }

    or

    class { 'fmw_inst':
      version             => 'c:\\java\\jdk1.7.0_75',
      middleware_home_dir => 'C:\\Oracle\\middleware_1036',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      java_home_dir => 'c:\\java\\jdk1.7.0_75',
      source_file   => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
      source_2_file => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
    }

#### Manifest service_bus

    class { 'fmw_inst':
      version             => '12.1.3',  # this is also the default
      middleware_home_dir => '/opt/oracle/middleware', # this is the default for linux and solaris
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::service_bus':
      java_home_dir => '/usr/java/jdk1.7.0_75',
      source_file   => '/software/fmw_12.1.3.0.0_osb_Disk1_1of1.zip',
    }

    or

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version => '12.1.3',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::service_bus':
      java_home_dir => '/usr/java/jdk1.7.0_75',
      source_file   => '/software/ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
    }

In hiera

    ---

    # executed manifest classes
    classes:
      - fmw_jdk::rng_service
      - fmw_jdk::install
      - fmw_wls::setup
      - fmw_wls::install
      - fmw_inst::service_bus

    # general variables
    java_home_dir:             &java_home_dir       '/usr/java/jdk1.7.0_75'
    version:                   &version             '12.1.3'
    middleware_home_dir:       &middleware_home_dir '/opt/oracle/middleware'

    # class parameters
    fmw_jdk::install::java_home_dir: *java_home_dir
    fmw_jdk::install::source_file:   '/software/jdk-7u75-linux-x64.tar.gz'

    fmw_wls::version:                *version                 # this is also the default
    fmw_wls::middleware_home_dir:    *middleware_home_dir     # this is the default for linux and solaris
    fmw_wls::install::java_home_dir: *java_home_dir
    fmw_wls::install::source_file:   '/software/fmw_12.1.3.0.0_infrastructure.jar'
    fmw_wls::install::install_type:  'infra'                  # 'wls' is the default

    fmw_inst::version:                    *version                # this is also the default
    fmw_inst::middleware_home_dir:        *middleware_home_dir    # this is the default for linux and solaris
    fmw_inst::service_bus::java_home_dir: *java_home_dir
    fmw_inst::service_bus::source_file:   '/software/fmw_12.1.3.0.0_osb_Disk1_1of1.zip'


Windows

    class { 'fmw_inst':
      version             => 'c:\\java\\jdk1.7.0_75',
      middleware_home_dir => 'C:\\Oracle\\middleware_1213',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::service_bus':
      java_home_dir => 'c:\\java\\jdk1.7.0_75',
      source_file   => 'c:\\software\\fmw_12.1.3.0.0_osb_Disk1_1of1.zip',
    }

    or

    class { 'fmw_inst':
      version             => 'c:\\java\\jdk1.7.0_75',
      middleware_home_dir => 'C:\\Oracle\\middleware_1036',
    }

    # this requires fmw_wls::install
    class { 'fmw_inst::service_bus':
      java_home_dir => 'c:\\java\\jdk1.7.0_75',
      source_file   => 'c:\\software\\ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
    }

#### Manifest mft

Only for FMW 12c

  # can be removed when all the default are used.
  class { 'fmw_inst':
    version             => '12.1.3',
    java_home_dir       => '/usr/java/jdk1.7.0_75',
    middleware_home_dir => '/opt/oracle/middleware_1213',
  }

  class { 'fmw_inst::mft':
    source_file   => '/software/fmw_12.1.3.0.0_mft_Disk1_1of1.zip',
  }


#### Manifest jrf

Only for FMW 11g, for 12c use the fmw_wls::install with the infra option.

    class { 'fmw_inst':
      version       => '10.3.6',
      java_home_dir => '/usr/java/jdk1.7.0_75',
    }


    class { 'fmw_inst::jrf':
      source_file   => '/software/ofm_appdev_generic_11.1.1.9.0_disk1_1of1.zip',
    }

#### Manifest oim


    class { 'fmw_inst':
      version       => '10.3.6',
      java_home_dir => '/usr/java/jdk1.7.0_75',
    }

    class { 'fmw_inst::oim':
      oim_version   => '11.1.2',
      source_file   => '/software/ofm_iam_generic_11.1.2.3.0_disk1_1of3.zip',
      source_2_file => '/software/ofm_iam_generic_11.1.2.3.0_disk1_2of3.zip',
      source_3_file => '/software/ofm_iam_generic_11.1.2.3.0_disk1_3of3.zip',
    }


## Limitations

This should work on Windows, Solaris, Linux (Any RedHat or Debian platform family distribution)

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
    SOFTWARE_FOLDER=/Users/edwinbiemond/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=oel-7.2-x64 bundle exec rspec spec/acceptance

    set SOFTWARE_FOLDER=c:/software
    set BEAKER_destroy=onpass
    set BEAKER_debug=true
    set BEAKER_set=centos-70-x64
    bundle exec rspec spec/acceptance

    bundle exec rake yard

    # Ruby on Windows
    use only 32-bits, its more stable, http://rubyinstaller.org/downloads/

    Ruby 2.0.0-p598 to C:\Ruby\200
    Ruby Development kit to C:\Ruby\2_devkit, so you can optionally build your gems

    set PATH=%PATH%;C:\Ruby\200\bin
    C:\Ruby\2_devkit\devkitvars.bat
    ruby -v