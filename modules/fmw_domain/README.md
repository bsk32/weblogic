# fmw_domain

#### Table of Contents

1. [Overview - What is the fmw_domain module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_domain](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: domain](#manifest-domain)
        * [Manifest: nodemanager](#manifest-nodemanager)
        * [Manifest: adminserver](#manifest-adminserver)
        * [Manifest: extension_jrf](#manifest-extension_jrf)
        * [Manifest: extension_webtier](#manifest-extension_webtier)
        * [Manifest: extension_service_bus](#manifest-extension_service_bus)
        * [Manifest: extension_soa_suite](#manifest-extension_soa_suite)
        * [Manifest: extension_bam](#manifest-extension_bam)
        * [Manifest: extension_enterprise_scheduler](#manifest-enterprise_scheduler)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_domain module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_domain module allows you to create a WebLogic (FMW) Domain with FMW extensions on a Windows, Linux or Solaris host.

## Module description

This module allows you to create a WebLogic (FMW) Domain (10.3.6, 12.1.1) or 12c (12.1.2, 12.1.3, 12.2.1, 12.2.1.1, '12.2.1.2' ) on any Windows, Linux or Solaris host or VM.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

This is an manifest for all fmw_module module atributes

    class { 'fmw_domain':
      version                       => '12.1.3',                                            # default '12.1.3'
      java_home_dir                 => '/usr/java/jdk1.7.0_75',
      middleware_home_dir           => '/opt/oracle/middleware',                            # unix '/opt/oracle/middleware', windows 'C:/oracle/middleware'
      weblogic_home_dir             => '/opt/oracle/middleware/wlserver',
      os_user                       =  'oracle',                                            # default 'oracle'
      os_group                      =  'oinstall',                                          # default 'oinstall'
      user_home_dir                 =  '/home',                                             # linux '/home', solaris '/export/home'
      tmp_dir                       => '/tmp',                                              # linux '/tmp', solaris '/var/tmp', windows 'C:/temp'
      domains_dir                   => '/opt/oracle/middleware/user_projects/domains',      # unix '/opt/oracle/middleware/user_projects/domains', windows 'C:/oracle/middleware/user_projects/domains'
      apps_dir                      => '/opt/oracle/middleware/user_projects/applications', # unix '/opt/oracle/middleware/user_projects/applications', windows 'C:/oracle/middleware/user_projects/applications'
      domain_name                   => 'base_domain',
      weblogic_user                 => 'weblogic',                                          # default 'weblogic'
      weblogic_password             => 'Welcome01',
      adminserver_name              => 'AdminServer',                                       # default 'AdminServer'
      adminserver_listen_address    => '10.10.10.81',
      adminserver_listen_port       => 7001,                                                # default 7001
      nodemanager_listen_address    => '10.10.10.81',
      nodemanager_listen_port       => 5556,                                                # default 5556
      restricted                    => false,                                               # default false , only for 12.2.1 use JRF/Webtier restricted templates without RCU
      soa_suite_cluster             => 'soa_cluster',
      soa_suite_install_type        => 'SOA Suite',                                         # default 'SOA Suite' or use 'BPM'
      service_bus_cluster           => 'sb_cluster',
      bam_cluster                   => 'bam_cluster',
      enterprise_scheduler_cluster  => 'ess_cluster',
      adminserver_startup_arguments => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m', # default '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m'
      osb_server_startup_arguments  => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m', # default '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m'
      soa_server_startup_arguments  => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m', # default '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m'
      bam_server_startup_arguments  => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m', # default '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m'
      ess_server_startup_arguments  => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m', # default '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m'
      repository_database_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      repository_prefix             => 'DEV22',
      repository_password           => 'Welcome02',
    }


#### Recipe domain

This will create a basic WebLogic domain optional with FMW domain extensions

Requires fmw_wls:install

On unix

    include fmw_jdk::rng_service

    $java_home_dir       = '/usr/java/jdk1.7.0_75'
    $version             = '12.1.3'
    $middleware_home_dir = '/opt/oracle/middleware'
    $weblogic_home_dir   = '/opt/oracle/middleware/wlserver'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    class { 'fmw_wls':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
    }

    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_wls::install
    class { 'fmw_opatch::weblogic':
      patch_id      => '20838345',
      source_file   => '/software/p20838345_121300_Generic.zip',
    }

    Class['fmw_opatch::weblogic'] ->
      Class['fmw_domain::domain']

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
      apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
      domain_name                   => 'base_domain',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '10.10.10.81',
      nodemanager_listen_address    => '10.10.10.81',
    }

    include fmw_domain::domain
    include fmw_domain::nodemanager
    include fmw_domain::adminserver

On windows

    $java_home_dir       = 'c:\\java\\jdk1.7.0_75'
    $middleware_home_dir = 'c:\\Oracle\\middleware_1213'
    $weblogic_home_dir   = 'c:\\oracle\\middleware_1213\\wlserver'
    $version             = '12.1.3'

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
    }

    class { 'fmw_wls':
      version             => $version,  # this is also the default
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\fmw_12.1.3.0.0_wls.jar',
    }

    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_wls::install
    class { 'fmw_opatch::weblogic':
      patch_id      => '20838345',
      source_file   => 'c:\\software\\p20838345_121300_Generic.zip',
    }

    Class['fmw_opatch::weblogic'] ->
      Class['fmw_domain::domain']

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => 'c:\\oracle\\middleware_1213\\user_projects\\domains',
      apps_dir                      => 'c:\\oracle\\middleware_1213\\user_projects\\applications',
      domain_name                   => 'base_domain',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '192.168.2.101',
      nodemanager_listen_address    => '192.168.2.101',
    }

    include fmw_domain::domain
    include fmw_domain::nodemanager
    include fmw_domain::adminserver


Same but with some clusters, servers and nodemanagers

    include fmw_jdk::rng_service

    $java_home_dir       = '/usr/java/jdk1.7.0_75'
    $version             = '12.1.3'
    $middleware_home_dir = '/opt/oracle/middleware'
    $weblogic_home_dir   = '/opt/oracle/middleware/wlserver'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    class { 'fmw_wls':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
    }

    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_wls::install
    class { 'fmw_opatch::weblogic':
      patch_id      => '20838345',
      source_file   => '/software/p20838345_121300_Generic.zip',
    }

    Class['fmw_opatch::weblogic'] ->
      Class['fmw_domain::domain']

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
      apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
      domain_name                   => 'base_domain',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '10.10.10.81',
      nodemanager_listen_address    => '10.10.10.81',
    }

    class { 'fmw_domain::domain':
      nodemanagers => [ { "id" => "node1",
                          "listen_address" => "10.10.10.81"
                        },
                        { "id" => "node2",
                          "listen_address" => "10.10.10.81"
                        }],
      servers      =>  [
        { "id"             => "server1",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "server2",
          "nodemanager"    => "node2",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8002,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "server3",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 9001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        }],
      clusters      => [
        { "id"      => "cluster1",
          "members" => ["server1","server2"]
        },
        { "id"      => "cluster2",
          "members" => ["server3"]
        }
      ],
    }

    include fmw_domain::nodemanager
    include fmw_domain::adminserver

With Fusion Middleware 12c

    include fmw_jdk::rng_service

    $java_home_dir       = '/usr/java/jdk1.7.0_75'
    $version             = '12.1.3'
    $middleware_home_dir = '/opt/oracle/middleware'
    $weblogic_home_dir   = '/opt/oracle/middleware/wlserver'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    class { 'fmw_wls':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_infrastructure.jar',
      install_type  => 'infra', # 'wls' is the default
    }

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    Class['fmw_inst::soa_suite'] ->
      Class['fmw_inst::service_bus']


    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      source_file   => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
      install_type  => 'BPM',
    }

    class { 'fmw_inst::service_bus':
      source_file   => '/software/fmw_12.1.3.0.0_osb_Disk1_1of1.zip',
    }

    # can be removed when all the default are used.
    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_inst::soa_suite
    class { 'fmw_opatch::soa_suite':
      patch_id      => '20423408',
      source_file   => '/software/p20423408_121300_Generic.zip',
    }

    # this requires fmw_wls::install
    class { 'fmw_opatch::weblogic':
      patch_id      => '20838345',
      source_file   => '/software/p20838345_121300_Generic.zip',
    }

    Class['fmw_opatch::weblogic'] ->
      Class['fmw_opatch::soa_suite'] ->
        Class['fmw_rcu::soa_suite'] ->
          Class['fmw_domain::domain']

    class {'fmw_rcu::soa_suite':
      version                => $version,
      java_home_dir          => $java_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      oracle_home_dir        => '/opt/oracle/middleware/oracle_common',
      rcu_prefix             => 'DEV22',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
      apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
      domain_name                   => 'base_domain',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '10.10.10.81',
      nodemanager_listen_address    => '10.10.10.81',
      soa_suite_install_type        => 'BPM',
      repository_database_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      repository_prefix             => 'DEV22',
      repository_password           => 'Welcome02',
    }

    include fmw_domain::domain

    Class['fmw_domain::extension_soa_suite'] ->
      Class['fmw_domain::extension_service_bus'] ->
        Class['fmw_domain::extension_bam'] ->
          Class['fmw_domain::extension_enterprise_scheduler'] ->
            Class['fmw_domain::nodemanager'] ->
              Class['fmw_domain::adminserver']

    include fmw_domain::extension_soa_suite
    include fmw_domain::extension_service_bus
    include fmw_domain::extension_bam
    include fmw_domain::extension_enterprise_scheduler
    include fmw_domain::nodemanager
    include fmw_domain::adminserver


With Fusion Middleware 11g on windows

    $java_home_dir       = 'c:\\java\\jdk1.7.0_75'
    $middleware_home_dir = 'C:\\Oracle\\middleware_1036'
    $weblogic_home_dir   = 'c:\\oracle\\middleware_1036\\wlserver_10.3'
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

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    Class['fmw_bsu::weblogic'] ->
      Class['fmw_inst::soa_suite'] ->
        Class['fmw_inst::service_bus']

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      source_file   => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
      source_2_file => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
    }

    class { 'fmw_inst::service_bus':
      source_file   => 'c:\\software\\ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
    }

    # can be removed when all the default are used.
    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_inst::soa_suite
    class { 'fmw_opatch::soa_suite':
      patch_id      => '20423535',
      source_file   => 'c:\\software\\p20423535_111170_Generic.zip',
    }

    # this requires fmw_inst::service_bus
    class { 'fmw_opatch::service_bus':
      patch_id      => '20423630',
      source_file   => 'c:\\software\\p20423630_111170_Generic.zip',
    }

    Class['fmw_opatch::soa_suite'] ->
      Class['fmw_opatch::service_bus'] ->
        Class['fmw_rcu::soa_suite'] ->
          Class['fmw_domain::domain']

    class {'fmw_rcu::soa_suite':
      version                => $version,
      java_home_dir          => $java_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      source_file            => 'c:\\software\\ofm_rcu_win_11.1.1.7.0_32_disk1_1of1.zip',
      oracle_home_dir        => 'c:\\Oracle\\middleware_1036\\oracle_common',
      rcu_prefix             => 'DEV32',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => 'c:\\oracle\\middleware_1036\\user_projects\\domains',
      apps_dir                      => 'c:\\oracle\\middleware_1036\\user_projects\\applications',
      domain_name                   => 'base_all',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '192.168.2.101',
      nodemanager_listen_address    => '192.168.2.101',
      soa_suite_cluster             => 'soa_cluster',
      soa_suite_install_type        => 'BPM',
      service_bus_cluster           => 'sb_cluster',
      bam_cluster                   => 'bam_cluster',
      repository_database_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      repository_prefix             => 'DEV32',
      repository_password           => 'Welcome02',
    }

    include fmw_domain::domain

    Class['fmw_domain::extension_soa_suite'] ->
      Class['fmw_domain::extension_service_bus'] ->
        Class['fmw_domain::extension_bam'] ->
          Class['fmw_domain::nodemanager'] ->
            Class['fmw_domain::adminserver']

    include fmw_domain::extension_soa_suite
    include fmw_domain::extension_service_bus
    include fmw_domain::extension_bam
    include fmw_domain::nodemanager
    include fmw_domain::adminserver

With Fusion Middleware in a cluster configuration

    include fmw_jdk::rng_service

    $java_home_dir       = '/usr/java/jdk1.7.0_75'
    $version             = '12.1.3'
    $middleware_home_dir = '/opt/oracle/middleware'
    $weblogic_home_dir   = '/opt/oracle/middleware/wlserver'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    class { 'fmw_wls':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_infrastructure.jar',
      install_type  => 'infra', # 'wls' is the default
    }

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }


    Class['fmw_inst::soa_suite'] ->
      Class['fmw_inst::service_bus']


    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      source_file   => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
      install_type  => 'BPM',
    }

    class { 'fmw_inst::service_bus':
      source_file   => '/software/fmw_12.1.3.0.0_osb_Disk1_1of1.zip',
    }

    # can be removed when all the default are used.
    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_inst::soa_suite
    class { 'fmw_opatch::soa_suite':
      patch_id      => '20423408',
      source_file   => '/software/p20423408_121300_Generic.zip',
    }

    # this requires fmw_wls::install
    class { 'fmw_opatch::weblogic':
      patch_id      => '20838345',
      source_file   => '/software/p20838345_121300_Generic.zip',
    }

    Class['fmw_opatch::weblogic'] ->
      Class['fmw_opatch::soa_suite'] ->
        Class['fmw_rcu::soa_suite'] ->
          Class['fmw_domain::domain']

    class {'fmw_rcu::soa_suite':
      version                => $version,
      java_home_dir          => $java_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      oracle_home_dir        => '/opt/oracle/middleware/oracle_common',
      rcu_prefix             => 'DEV22',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
      apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
      domain_name                   => 'base_domain',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '10.10.10.81',
      nodemanager_listen_address    => '10.10.10.81',
      soa_suite_cluster             => 'soa_cluster',
      soa_suite_install_type        => 'BPM',
      service_bus_cluster           => 'sb_cluster',
      bam_cluster                   => 'bam_cluster',
      enterprise_scheduler_cluster  => 'ess_cluster',
      repository_database_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      repository_prefix             => 'DEV22',
      repository_password           => 'Welcome02',
    }

    class { 'fmw_domain::domain':
      nodemanagers => [ { "id" => "node1",
                          "listen_address" => "10.10.10.81"
                        },
                        { "id" => "node2",
                          "listen_address" => "10.10.10.81"
                        }],
      servers      =>  [
        { "id"             => "soa12c_server1",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "soa12c_server2",
          "nodemanager"    => "node2",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8002,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "sb12c_server1",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8011,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "sb12c_server2",
          "nodemanager"    => "node2",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8012,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "bam12c_server1",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 9001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "bam12c_server2",
          "nodemanager"    => "node2",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 9002,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "ess12c_server1",
          "nodemanager"    => "node1",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8201,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "ess12c_server2",
          "nodemanager"    => "node2",
          "listen_address" => "10.10.10.81",
          "listen_port"    => 8202,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        }],
      clusters      => [
        { "id"      => "soa_cluster",
          "members" => ["soa12c_server1","soa12c_server2"]
        },
        { "id"      => "sb_cluster",
          "members" => ["sb12c_server1","sb12c_server2"]
        },
        { "id"      => "bam_cluster",
          "members" => ["bam12c_server1","bam12c_server2"]
        },
        { "id"      => "ess_cluster",
          "members" => ["ess12c_server1","ess12c_server2"]
        }
        ],
    }

    Class['fmw_domain::extension_soa_suite'] ->
      Class['fmw_domain::extension_service_bus'] ->
        Class['fmw_domain::extension_bam'] ->
          Class['fmw_domain::extension_enterprise_scheduler'] ->
            Class['fmw_domain::nodemanager'] ->
              Class['fmw_domain::adminserver']

    include fmw_domain::extension_soa_suite
    include fmw_domain::extension_service_bus
    include fmw_domain::extension_bam
    include fmw_domain::extension_enterprise_scheduler
    include fmw_domain::nodemanager
    include fmw_domain::adminserver

With Fusion Middleware 11g in a cluster configuration on windows

    $java_home_dir       = 'c:\\java\\jdk1.7.0_75'
    $middleware_home_dir = 'C:\\Oracle\\middleware_1036'
    $weblogic_home_dir   = 'c:\\oracle\\middleware_1036\\wlserver_10.3'
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

    # can be removed when all the default are used.
    class { 'fmw_inst':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    Class['fmw_bsu::weblogic'] ->
      Class['fmw_inst::soa_suite'] ->
        Class['fmw_inst::service_bus']

    # this requires fmw_wls::install
    class { 'fmw_inst::soa_suite':
      source_file   => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
      source_2_file => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
    }

    class { 'fmw_inst::service_bus':
      source_file   => 'c:\\software\\ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
    }

    # can be removed when all the default are used.
    class { 'fmw_opatch':
      version             => $version,
      java_home_dir       => $java_home_dir,
      middleware_home_dir => $middleware_home_dir,
    }

    # this requires fmw_inst::soa_suite
    class { 'fmw_opatch::soa_suite':
      patch_id      => '20423535',
      source_file   => 'c:\\software\\p20423535_111170_Generic.zip',
    }

    # this requires fmw_inst::service_bus
    class { 'fmw_opatch::service_bus':
      patch_id      => '20423630',
      source_file   => 'c:\\software\\p20423630_111170_Generic.zip',
    }

    Class['fmw_opatch::soa_suite'] ->
      Class['fmw_opatch::service_bus'] ->
        Class['fmw_rcu::soa_suite'] ->
          Class['fmw_domain::domain']

    class {'fmw_rcu::soa_suite':
      version                => $version,
      java_home_dir          => $java_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      source_file            => 'c:\\software\\ofm_rcu_win_11.1.1.7.0_32_disk1_1of1.zip',
      oracle_home_dir        => 'c:\\Oracle\\middleware_1036\\oracle_common',
      rcu_prefix             => 'DEV32',
      jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
      db_connect_password    => 'Welcome01',
      rcu_component_password => 'Welcome02',
    }

    class { 'fmw_domain':
      version                       => $version,
      java_home_dir                 => $java_home_dir,
      middleware_home_dir           => $middleware_home_dir,
      weblogic_home_dir             => $weblogic_home_dir,
      domains_dir                   => 'c:\\oracle\\middleware_1036\\user_projects\\domains',
      apps_dir                      => 'c:\\oracle\\middleware_1036\\user_projects\\applications',
      domain_name                   => 'base_all',
      weblogic_password             => 'Welcome01',
      adminserver_listen_address    => '192.168.2.101',
      nodemanager_listen_address    => '192.168.2.101',
      soa_suite_cluster             => 'soa_cluster',
      soa_suite_install_type        => 'BPM',
      service_bus_cluster           => 'sb_cluster',
      bam_cluster                   => 'bam_cluster',
      repository_database_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
      repository_prefix             => 'DEV32',
      repository_password           => 'Welcome02',
    }

    class { 'fmw_domain::domain':
      nodemanagers => [ { "id" => "node1",
                          "listen_address" => "192.168.2.101"
                        },
                        { "id" => "node2",
                          "listen_address" => "192.168.2.101"
                        }],
      servers      =>  [
        { "id"             => "soa11g_server1",
          "nodemanager"    => "node1",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 8001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Dtangosol.coherence.wka1=192.168.2.101 -Dtangosol.coherence.wka2=192.168.2.101 -Dtangosol.coherence.localhost=192.168.2.101 -Dtangosol.coherence.localport=8089 -Dtangosol.coherence.wka1.port=8089 -Dtangosol.coherence.wka2.port=8189"
        },
        { "id"             => "soa11g_server2",
          "nodemanager"    => "node2",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 8002,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Dtangosol.coherence.wka1=192.168.2.101 -Dtangosol.coherence.wka2=192.168.2.101 -Dtangosol.coherence.localhost=192.168.2.101 -Dtangosol.coherence.localport=8189 -Dtangosol.coherence.wka1.port=8089 -Dtangosol.coherence.wka2.port=8189"
        },
        { "id"             => "sb11g_server1",
          "nodemanager"    => "node1",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 8011,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -DOSB.coherence.localhost=192.168.2.101 -DOSB.coherence.localport=7890 -DOSB.coherence.wka1=192.168.2.101 -DOSB.coherence.wka1.port=7890 -DOSB.coherence.wka2=192.168.2.101 -DOSB.coherence.wka2.port=7891"
        },
        { "id"             => "sb11g_server2",
          "nodemanager"    => "node2",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 8012,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -DOSB.coherence.localhost=192.168.2.101 -DOSB.coherence.localport=7891 -DOSB.coherence.wka1=192.168.2.101 -DOSB.coherence.wka1.port=7890 -DOSB.coherence.wka2=192.168.2.101 -DOSB.coherence.wka2.port=7891"
        },
        { "id"             => "bam11g_server1",
          "nodemanager"    => "node1",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 9001,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        },
        { "id"             => "bam11g_server2",
          "nodemanager"    => "node2",
          "listen_address" => "192.168.2.101",
          "listen_port"    => 9002,
          "arguments"      => "-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m"
        }],
      clusters      => [
        { "id"      => "soa_cluster",
          "members" => ["soa11g_server1","soa11g_server2"]
        },
        { "id"      => "sb_cluster",
          "members" => ["sb11g_server1","sb11g_server2"]
        },
        { "id"      => "bam_cluster",
          "members" => ["bam11g_server1","bam11g_server2"]
        }],
    }

    Class['fmw_domain::extension_soa_suite'] ->
      Class['fmw_domain::extension_service_bus'] ->
        Class['fmw_domain::extension_bam'] ->
          Class['fmw_domain::nodemanager'] ->
            Class['fmw_domain::adminserver']

    include fmw_domain::extension_soa_suite
    include fmw_domain::extension_service_bus
    include fmw_domain::extension_bam
    include fmw_domain::nodemanager
    include fmw_domain::adminserver

#### Manifest nodemanager

Configures the nodemanager, create and starts the nodemanager service

#### Manifest adminserver

Starts or stops the AdminServer WebLogic instance by connecting to the nodemanager

#### Manifest extension_jrf

Extend the standard domain with JRF (ADF) and the Enterprise Manager (EM), requires in 12c fmw_wls::install with the infra option plus a common database repository created by RCU (fmw_rcu module, for 12.2.1 you can set fmw_domain restricted = true, this requires not a database repository) or for 11g fmw_wls::install together with a FMW product install like OSB, SOA Suite etc.

With WebLogic infrastructure 12.2.1 you have the option to use the restricted JRF templates. This requires not a database repository for OPSS. To enable this you can set  fmw_domain::restricted = true.

#### Manifest extension_webtier

Only for 12c, Extend the standard domain with Webtier. This also requires a common database repository created by RCU (fmw_rcu module, for 12.2.1 you can set fmw_domain restricted = true, this requires not a database repository).

With WebLogic infrastructure 12.2.1 you have the option to use the restricted JRF/Webtier templates. This requires not a database repository for OPSS. To enable this you can set  fmw_domain restricted = true.

#### Manifest extension_service_bus

Extend the standard domain with Oracle Service Bus, requires fmw_wls::install and fmw_inst::service_bus

#### Manifest extension_soa_suite

Extend the standard domain with Oracle SOA Suite. Optional add the BPM template to the domain by setting soa_suite_install_type attribute value to 'BPM'. Requires fmw_wls::install and fmw_inst::soa_suite

#### Manifest extension_bam

Extend the standard domain with BAM of Oracle SOA Suite. Requires fmw_wls::install and fmw-inst::soa_suite

#### Manifest extension_enterpise_scheduler

Extend the standard domain with Enterprise Schuduler (ESS) of Oracle SOA Suite 12c, is only available for WebLogic 12.1.3 and higher. Requires fmw_wls::install and fmw_inst::soa_suite


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
    gem install bundler -v 1.7.15 --no-rdoc --no-ri

    bundle install --without development

    bundle exec rake syntax
    bundle exec rake lint
    # symbolic error under windows , https://github.com/mitchellh/vagrant/issues/713#issuecomment-13201507. start vagrant in admin cmd session
    bundle exec rake spec
    bundle exec rubocop

    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=centos-70-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=solaris-10-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=solaris-11.2-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/Users/edwinbiemond/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=oel-7.2-x64 bundle exec rspec spec/acceptance

    # Ruby on Windows
    use only 32-bits, its more stable, http://rubyinstaller.org/downloads/

    Ruby 2.0.0-p598 to C:\Ruby\200
    Ruby Development kit to C:\Ruby\2_devkit, so you can optionally build your gems

    set PATH=%PATH%;C:\Ruby\200_puppet\bin
    C:\Ruby\2_devkit\devkitvars.bat
    ruby -v

    set SOFTWARE_FOLDER=c:/software
    set BEAKER_destroy=onpass
    set BEAKER_debug=true
    set BEAKER_set=debian-78-x64
    set BEAKER_set=solaris-10-x64
    set BEAKER_set=solaris-11.2-x64
    bundle exec rspec spec/acceptance

