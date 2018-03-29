#
# fmw_inst::internal::fmw_extract_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_inst::internal::fmw_extract_windows(
  $version             = undef,
  $middleware_home_dir = undef,
  $source_file         = undef,
  $source_2_file       = undef,
  $source_3_file       = undef,
  $create_file_check   = undef,
  $create_2_file_check = undef,
  $create_3_file_check = undef,
  $tmp_dir             = undef,
)
{
  if $version == '10.3.6' {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\wlserver_10.3\\server\\adr"
  } elsif $version == '12.1.1' {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\wlserver_12.1\\server\\adr"
  } else {
    $path = "C:\\Windows\\system32;C:\\Windows;${middleware_home_dir}\\oracle_common\\adr"
  }

  exec{ "extract ${title} file 1":
    command => "unzip -o ${source_file} -d ${tmp_dir}/${title}",
    creates => $create_file_check,
    cwd     => $tmp_dir,
    path    => $path,
    timeout => 0,
  }

  if ( $source_2_file != undef ) {
    exec{ "extract ${title} file 2":
      command => "unzip -o ${source_2_file} -d ${tmp_dir}/${title}",
      creates => $create_2_file_check,
      cwd     => $tmp_dir,
      path    => $path,
      timeout => 0,
      require => Exec["extract ${title} file 1"],
    }
  }

  if ( $source_3_file != undef ) {
    exec{ "extract ${title} file 3":
      command => "unzip -o ${source_3_file} -d ${tmp_dir}/${title}",
      creates => $create_3_file_check,
      cwd     => $tmp_dir,
      path    => $path,
      timeout => 0,
      require => Exec["extract ${title} file 2"],
    }
  }
}
