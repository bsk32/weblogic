#
# fmw_bsu::internal::bsu_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_bsu::internal::bsu_windows(
  $version             = $fmw_bsu::params::version,
  $middleware_home_dir = $fmw_bsu::params::middleware_home_dir,
  $patch_id            = undef,
  $source_file         = undef,
)
{
  if $version == '10.3.6' {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\wlserver_10.3\\server\\adr"
    $weblogic_home_dir = "${middleware_home_dir}\\wlserver_10.3"
  } else {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\wlserver_12.1\\server\\adr"
    $weblogic_home_dir = "${middleware_home_dir}\\wlserver_12.1"
  }

  file { "${middleware_home_dir}\\utils\\bsu\\cache_dir":
    ensure => directory,
  }

  exec{ "extract ${patch_id}":
    command => "unzip -o ${source_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
    creates => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
    timeout => 0,
    require => File["${middleware_home_dir}\\utils\\bsu\\cache_dir"],
    path    => $path,
  }

  fmw_bsu_patch { $patch_id:
    ensure              => 'present',
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    require             => Exec["extract ${patch_id}"],
  }
}