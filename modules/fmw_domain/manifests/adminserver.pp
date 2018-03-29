#
# fmw_domain::adminserver
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::adminserver()
{
  require fmw_domain::nodemanager

  if $::kernel in ['Linux', 'SunOS'] {
    fmw_domain_adminserver{$fmw_domain::domain_name:
      ensure                     => 'running',
      domain_dir                 => "${fmw_domain::domains_dir}/${fmw_domain::domain_name}",
      domain_name                => $fmw_domain::domain_name,
      adminserver_name           => $fmw_domain::adminserver_name,
      weblogic_home_dir          => $fmw_domain::weblogic_home_dir,
      java_home_dir              => $fmw_domain::java_home_dir,
      weblogic_user              => $fmw_domain::weblogic_user,
      weblogic_password          => $fmw_domain::weblogic_password,
      nodemanager_listen_address => $fmw_domain::nodemanager_listen_address,
      nodemanager_port           => $fmw_domain::nodemanager_port,
      os_user                    => $fmw_domain::os_user,
    }
  }
  elsif $::kernel in ['windows'] {
    $domain_dir = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")

    fmw_domain_adminserver{$fmw_domain::domain_name:
      ensure                     => 'running',
      domain_dir                 => $domain_dir,
      domain_name                => $fmw_domain::domain_name,
      adminserver_name           => $fmw_domain::adminserver_name,
      weblogic_home_dir          => $fmw_domain::weblogic_home_dir,
      java_home_dir              => $fmw_domain::java_home_dir,
      weblogic_user              => $fmw_domain::weblogic_user,
      weblogic_password          => $fmw_domain::weblogic_password,
      nodemanager_listen_address => $fmw_domain::nodemanager_listen_address,
      nodemanager_port           => $fmw_domain::nodemanager_port,
    }
  }
}
