#
# fmw_inst::internal::fmw_extract
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_inst::internal::fmw_extract(
  $source_file         = undef,
  $source_2_file       = undef,
  $source_3_file       = undef,
  $create_file_check   = undef,
  $create_2_file_check = undef,
  $create_3_file_check = undef,
  $os_user             = undef,
  $os_group            = undef,
  $tmp_dir             = undef,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  if !defined(Package['unzip']) {
    package{ 'unzip':
      ensure => present,
    }
  }

  exec{ "extract ${title} file 1":
    command => "unzip -o ${source_file} -d ${tmp_dir}/${title}",
    creates => $create_file_check,
    user    => $os_user,
    group   => $os_group,
    cwd     => $tmp_dir,
    path    => $path,
    timeout => 0,
    require => Package['unzip'],
  }

  if ( $source_2_file != undef ) {
    exec{ "extract ${title} file 2":
      command => "unzip -o ${source_2_file} -d ${tmp_dir}/${title}",
      creates => $create_2_file_check,
      user    => $os_user,
      group   => $os_group,
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
      user    => $os_user,
      group   => $os_group,
      cwd     => $tmp_dir,
      path    => $path,
      timeout => 0,
      require => Exec["extract ${title} file 2"],
    }
  }
}
