#
# fmw_opatch::internal::fmw_extract
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_opatch::internal::fmw_extract(
  $source_file         = undef,
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

  exec{ "extract ${title}":
    command => "unzip -o ${source_file} -d ${tmp_dir}",
    creates => "${tmp_dir}/${title}",
    user    => $os_user,
    group   => $os_group,
    cwd     => $tmp_dir,
    path    => $path,
    timeout => 0,
    require => Package['unzip'],
  }

}
