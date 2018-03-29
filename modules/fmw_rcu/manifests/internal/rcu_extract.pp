#
# fmw_rcu::internal::rcu_extract
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_rcu::internal::rcu_extract(
  $source_file         = undef,
  $creates_dir         = undef,
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

  exec{ "extract rcu file ${title}":
    command => "unzip -o ${source_file} -d ${tmp_dir}/rcu",
    creates => $creates_dir,
    cwd     => $tmp_dir,
    path    => $path,
    user    => $os_user,
    group   => $os_group,
    timeout => 0,
    require => Package['unzip'],
  }
}
