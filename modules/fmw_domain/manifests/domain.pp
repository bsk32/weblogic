#
# fmw_domain::domain
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::domain(
  $nodemanagers = [],
  $servers      = [],
  $clusters     = [],
)
{

  require fmw_domain

  if ( $fmw_domain::weblogic_home_dir == undef or is_string($fmw_domain::weblogic_home_dir) == false ) {
    fail('weblogic_home_dir parameter cannot be empty')
  }

  require fmw_wls::install

  if $fmw_domain::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {
    $wls_base_template = "${fmw_domain::weblogic_home_dir}/common/templates/wls/wls.jar"
  } elsif $fmw_domain::version == '10.3.6' {
    $wls_base_template = "${fmw_domain::weblogic_home_dir}/common/templates/domains/wls.jar"
  }

  $domain_dir = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_domain::tmp_dir}/common.py":
      ensure => present,
      source => 'puppet:///modules/fmw_domain/domain/common.py',
      mode   => '0755',
      owner  => $fmw_domain::os_user,
      group  => $fmw_domain::os_group,
    }

    file { "${fmw_domain::tmp_dir}/domain.py":
      ensure  => present,
      content => template('fmw_domain/domain/domain.py'),
      mode    => '0755',
      owner   => $fmw_domain::os_user,
      group   => $fmw_domain::os_group,
    }

    $domain_parent_dir = fmw_domain_parent_folder($fmw_domain::domains_dir)

    # make sure the middleware parent directory exists
    file { $domain_parent_dir:
      ensure => directory,
      mode   => '0775',
      owner  => $fmw_domain::os_user,
      group  => $fmw_domain::os_group,
    }

    file { $fmw_domain::domains_dir:
      ensure  => directory,
      mode    => '0775',
      owner   => $fmw_domain::os_user,
      group   => $fmw_domain::os_group,
      require => File[$domain_parent_dir],
    }

    # create domain
    fmw_domain_wlst{'WLST create domain':
      ensure              => 'present',
      version             => $fmw_domain::version,
      script_file         => "${fmw_domain::tmp_dir}/domain.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      os_user             => $fmw_domain::os_user,
      weblogic_password   => $fmw_domain::weblogic_password,
      require             => File[$fmw_domain::domains_dir,"${fmw_domain::tmp_dir}/domain.py","${fmw_domain::tmp_dir}/common.py"],
    }

  } elsif $::kernel in ['windows'] {
    file { "${fmw_domain::tmp_dir}/common.py":
      ensure             => present,
      source             => 'puppet:///modules/fmw_domain/domain/common.py',
      source_permissions => ignore,
    }

    file { "${fmw_domain::tmp_dir}/domain.py":
      ensure             => present,
      content            => template('fmw_domain/domain/domain.py'),
      source_permissions => ignore,
    }

    $domain_parent_dir = fmw_domain_parent_folder($fmw_domain::domains_dir)

    # make sure the middleware parent directory exists
    file { $domain_parent_dir:
      ensure => directory,
    }

    file { $fmw_domain::domains_dir:
      ensure  => directory,
      require => File[$domain_parent_dir],
    }

    # create domain
    fmw_domain_wlst{'WLST create domain':
      ensure              => 'present',
      version             => $fmw_domain::version,
      script_file         => "${fmw_domain::tmp_dir}/domain.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      weblogic_password   => $fmw_domain::weblogic_password,
      require             => File[$fmw_domain::domains_dir,"${fmw_domain::tmp_dir}/domain.py","${fmw_domain::tmp_dir}/common.py"],
    }

  }


}