# fmw_bsu

#### Table of Contents

1. [Overview - What is the fmw_bsu module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_bsu](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: weblogic](#manifest-weblogic)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_bsu module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_bsu module allows you to patch Oracle WebLogic 10.3.6 or 12.1.1.

## Module description

This modules allows you to patch Oracle WebLogic 10.3.6 or 12.1.1, this won't work on WebLogic 12.1.2  or higher. For WebLogic 12c you can use the fmw_opatch module.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

--

#### Manifest weblogic

This will install the 10.3.6 or 12.1.1 WebLogic BSU patch and has a dependency with the fmw_wls::install recipe

used defaults

    class fmw_bsu::params()
    {
      $version       = '12.1.3' # 10.3.6|12.1.1

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

    }

site.pp

    include fmw_jdk::rng_service

    $java_home_dir = '/usr/java/jdk1.7.0_75'
    $version       = '10.3.6'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    # can be removed when all the default are used.
    class { 'fmw_wls':
      version             => $version,
    }

    include fmw_wls::setup

    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/wls1036_generic.jar',
    }

    class { 'fmw_bsu::weblogic':
      version             => $version,
      patch_id            => 'YUIS',
      source_file         => '/software/p20181997_1036_Generic.zip',
    }


Windows

    $java_home_dir       = 'c:\\java\\jdk1.7.0_75'
    $middleware_home_dir = 'C:\\Oracle\\middleware_1036'
    $version             = '10.3.6'

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
    }

    # can be removed when all the default are used.
    class { 'fmw_wls':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\wls1036_generic.jar',
    }

    # this requires fmw_wls::install
    class { 'fmw_bsu::weblogic':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
      patch_id            => 'YUIS',
      source_file         => 'c:\\software\\p20181997_1036_Generic.zip',
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