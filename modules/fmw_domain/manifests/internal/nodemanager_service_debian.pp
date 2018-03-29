#
# fmw_domain::internal::nodemanager_service_debian
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::internal::nodemanager_service_debian(
  $script_name = undef
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  exec{ "update-rc.d ${script_name}":
    command => "update-rc.d ${script_name} defaults",
    unless  => "ls /etc/rc3.d/*${script_name} | /bin/grep '${script_name}'",
    path    => $path,
  }

  service { $script_name:
    ensure  => 'running',
    enable  => true,
    require => Exec["update-rc.d ${script_name}"],
  }

}
