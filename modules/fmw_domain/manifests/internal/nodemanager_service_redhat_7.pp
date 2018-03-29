#
# fmw_domain::internal::nodemanager_service_redhat_7
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::internal::nodemanager_service_redhat_7(
  $script_name = undef
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  $user_home_dir =  $fmw_domain::user_home_dir
  $os_user       =  $fmw_domain::os_user

  file { "/lib/systemd/system/${script_name}.service":
    ensure  => present,
    content => regsubst(template('fmw_domain/nodemanager/systemd'), '\r\n', "\n", 'EMG'),
    mode    => '0755',
    owner   => $fmw_domain::os_user,
    group   => $fmw_domain::os_group,
  }

  exec { 'systemctl-daemon-reload-nodemanager':
    command     => '/bin/systemctl --system daemon-reload',
    path        => $path,
    subscribe   => File["/lib/systemd/system/${script_name}.service"],
    refreshonly => true,
    notify      => Service["${script_name}.service"],
  }

  exec { 'systemctl-enable-nodemanager':
    command     => "/bin/systemctl enable ${script_name}.service",
    path        => $path,
    subscribe   => Exec['systemctl-daemon-reload-nodemanager'],
    refreshonly => true,
    notify      => Service["${script_name}.service"],
    unless      => "/bin/systemctl list-units --type service --all | /bin/grep '${script_name}.service'",
  }

  service { "${script_name}.service":
    ensure  => 'running',
    enable  => true,
    require => Exec['systemctl-daemon-reload-nodemanager','systemctl-enable-nodemanager'],
  }

}
