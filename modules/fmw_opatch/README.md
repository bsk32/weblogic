# fmw_opatch

#### Table of Contents

1. [Overview - What is the fmw_opatch module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_opatch](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: service_bus](#manifest-service_bus)
        * [Manifest: soa_suite](#manifest-soa_suite)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_opatch module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_opatch module allows you to Patch Oracle WebLogic 12c or any FMW 11g or 12c product.

## Module description

This modules allows you to patch WebLogic 12c middleware environment or any FMW 11g or 12c product like SOA Suite, Service Bus etc.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

--

#### Manifest soa_suite

#### Manifest service_bus



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