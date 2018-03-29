#
# fmw_bsu::weblogic
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_bsu::weblogic(
  $version             = $fmw_bsu::params::version,
  $middleware_home_dir = $fmw_bsu::params::middleware_home_dir,
  $patch_id            = undef,
  $source_file         = undef,
  $os_user             = $fmw_bsu::params::os_user,
  $os_group            = $fmw_bsu::params::os_group,
  $tmp_dir             = $fmw_bsu::params::tmp_dir,
) inherits fmw_bsu::params {

  require fmw_wls::install

  unless $version in ['10.3.6', '12.1.1'] {
    fail('Not supported WebLogic version, please use it on WebLogic 10.3.6 or 12.1.1')
  }
  if ( $patch_id == undef or is_string($patch_id) == false ) {
    fail('patch_id parameter cannot be empty')
  }
  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  if $::kernel in ['Linux', 'SunOS'] {
    class{'fmw_bsu::internal::bsu':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
      patch_id            => $patch_id,
      source_file         => $source_file,
      os_user             => $os_user,
      os_group            => $os_group,
      tmp_dir             => $tmp_dir,
    }
    contain fmw_bsu::internal::bsu
  } elsif $::kernel == 'windows' {
    class{'fmw_bsu::internal::bsu_windows':
      version             => $version,
      middleware_home_dir => $middleware_home_dir,
      patch_id            => $patch_id,
      source_file         => $source_file,
    }
    contain fmw_bsu::internal::bsu_windows
  }
}
