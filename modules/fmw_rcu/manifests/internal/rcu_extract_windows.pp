#
# fmw_rcu::internal::rcu_extract_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_rcu::internal::rcu_extract_windows(
  $version             = undef,
  $middleware_home_dir = undef,
  $source_file         = undef,
  $creates_dir         = undef,
  $tmp_dir             = undef,
)
{
  if $version == '10.3.6' {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\wlserver_10.3\\server\\adr"
  } else {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\oracle_common\\adr"
  }

  exec{ "extract rcu file ${title}":
    command => "unzip -o ${source_file} -d ${tmp_dir}\\rcu",
    creates => $creates_dir ,
    cwd     => $tmp_dir,
    path    => $path,
    timeout => 0,
  }
}
