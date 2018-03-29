#
# fmw_domain::internal::nodemanager_service_solaris
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::internal::nodemanager_service_solaris(
  $script_name          = undef,
  $nodemanager_bin_path = undef,
)
{
  $os_user              = $fmw_domain::os_user
  $service_name         = $script_name

  # add solaris smf script to the right location
  file { "/etc/${script_name}":
    ensure  => present,
    content => regsubst(template('fmw_domain/nodemanager/nodemanager_solaris'), '\r\n', "\n", 'EMG'),
    mode    => '0755',
  }

  file { "${fmw_domain::tmp_dir}/nodemanager_smf_${service_name}.xml":
    ensure  => present,
    content => regsubst(template('fmw_domain/nodemanager/nodemanager_smf.xml'), '\r\n', "\n", 'EMG'),
    mode    => '0755',
  }

  exec{ "svvcfg ${script_name} import":
    command => "svccfg -v import ${fmw_domain::tmp_dir}/nodemanager_smf_${service_name}.xml",
    path    => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
    unless  => "svccfg list | grep ${script_name}",
    require => File["/etc/${script_name}","${fmw_domain::tmp_dir}/nodemanager_smf_${service_name}.xml"],
  }

  service { $script_name:
    ensure  => 'running',
    enable  => true,
    require => Exec["svvcfg ${script_name} import"],
  }

}
