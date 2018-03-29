#
# fmw_domain::internal::nodemanager_service_redhat
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::internal::nodemanager_service_redhat(
  $script_name = undef
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  exec{ "chkconfig ${script_name}":
    command => "chkconfig --add ${script_name}",
    unless  => "chkconfig | /bin/grep '${script_name}'",
    path    => $path,
  }

  service { $script_name:
    ensure  => 'running',
    enable  => true,
    require => Exec["chkconfig ${script_name}"],
  }

}
