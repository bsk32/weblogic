#
# fmw_rcu::common
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_rcu::common(
  $version                = $fmw_rcu::params::version,
  $java_home_dir          = undef,
  $middleware_home_dir    = $fmw_rcu::params::middleware_home_dir,
  $oracle_home_dir        = undef,
  $source_file            = undef,
  $jdbc_connect_url       = undef,
  $db_connect_url         = undef,
  $db_connect_user        = $fmw_rcu::params::db_sys_user,
  $db_connect_password    = undef,
  $rcu_prefix             = $fmw_rcu::params::rcu_prefix,
  $rcu_component_password = undef,
  $os_user                = $fmw_rcu::params::os_user,
  $os_group               = $fmw_rcu::params::os_group,
  $tmp_dir                = $fmw_rcu::params::tmp_dir,
) inherits fmw_rcu::params {


  if $version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {
    if ( $oracle_home_dir == undef or is_string($oracle_home_dir) == false ) {
      fail('oracle_home_dir parameter cannot be empty')
    }

    require fmw_wls::install
    $rcu_oracle_home_dir = $oracle_home_dir
  }

  if $version in ['12.2.1', '12.2.1.1', '12.2.1.2'] {

    $component_array = ['MDS',
                        'IAU',
                        'IAU_APPEND',
                        'IAU_VIEWER',
                        'OPSS',
                        'WLS',
                        'STB',
                        'UCSUMS']

  } elsif $version == '12.1.3' {

    $component_array = ['MDS',
                        'IAU',
                        'IAU_APPEND',
                        'IAU_VIEWER',
                        'OPSS',
                        'WLS',
                        'UCSUMS']

  } elsif $version == '10.3.6' {
    if ( $source_file == undef or is_string($source_file) == false ) {
      fail('source_file parameter cannot be empty')
    }
    if $::kernel == 'SunOS' {
      fail('there is no rcu installer supported for solaris')
    }

    require fmw_wls::install

    $component_array = ['ORASDPM',
                        'MDS',
                        'OPSS']

    if $::kernel == 'windows' {
      $rcu_oracle_home_dir = "${tmp_dir}\\rcu\\rcuHome"
      fmw_rcu::internal::rcu_extract_windows{'common':
        version             => $version,
        middleware_home_dir => $middleware_home_dir,
        source_file         => $source_file,
        creates_dir         => $rcu_oracle_home_dir,
        tmp_dir             => $tmp_dir,
        before              => Fmw_rcu_repository[$rcu_prefix],
      }
    } else {
      $rcu_oracle_home_dir = "${tmp_dir}/rcu/rcuHome"
      fmw_rcu::internal::rcu_extract{'common':
        source_file => $source_file,
        creates_dir => $rcu_oracle_home_dir,
        os_user     => $os_user,
        os_group    => $os_group,
        tmp_dir     => $tmp_dir,
        before      => Fmw_rcu_repository[$rcu_prefix],
      }
    }
  }

  $password_file = "${tmp_dir}/common_rcu_password.txt"

  if $::kernel == 'windows' {
    if !defined(File["${tmp_dir}/checkrcu.py"]) {
      file { "${tmp_dir}/checkrcu.py":
        ensure             => present,
        source_permissions => ignore,
        source             => 'puppet:///modules/fmw_rcu/checkrcu.py',
      }
    }

    fmw_rcu_repository{$rcu_prefix:
      ensure                 => 'present',
      oracle_home_dir        => $rcu_oracle_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      java_home_dir          => $java_home_dir,
      tmp_dir                => $tmp_dir,
      version                => $version,
      jdbc_connect_url       => $jdbc_connect_url,
      db_connect_url         => $db_connect_url,
      db_connect_user        => $db_connect_user,
      db_connect_password    => $db_connect_password,
      rcu_components         => $component_array,
      rcu_component_password => $rcu_component_password,
      require                => File["${tmp_dir}/checkrcu.py"],
    }
  } else {
    if !defined(File["${tmp_dir}/checkrcu.py"]) {
      file { "${tmp_dir}/checkrcu.py":
        ensure => present,
        source => 'puppet:///modules/fmw_rcu/checkrcu.py',
        owner  => $os_user,
        group  => $os_group,
        mode   => '0775',
      }
    }

    fmw_rcu_repository{$rcu_prefix:
      ensure                 => 'present',
      os_user                => $os_user,
      os_group               => $os_group,
      oracle_home_dir        => $rcu_oracle_home_dir,
      middleware_home_dir    => $middleware_home_dir,
      java_home_dir          => $java_home_dir,
      tmp_dir                => $tmp_dir,
      version                => $version,
      jdbc_connect_url       => $jdbc_connect_url,
      db_connect_url         => $db_connect_url,
      db_connect_user        => $db_connect_user,
      db_connect_password    => $db_connect_password,
      rcu_components         => $component_array,
      rcu_component_password => $rcu_component_password,
      require                => File["${tmp_dir}/checkrcu.py"],
    }
  }
}
