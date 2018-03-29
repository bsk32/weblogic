#
# fmw_domain::internal::nodemanager_service_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::internal::nodemanager_service_windows(
  $bin_dir = undef,
)
{
  fmw_domain_add_nodemanager{"Add nodemanager for ${bin_dir}":
    ensure              => 'present',
    bin_dir             => $bin_dir,
    version             => $fmw_domain::version,
    domain_name         => $fmw_domain::domain_name,
    domain_dir          => "${fmw_domain::domains_dir}/${fmw_domain::domain_name}",
    middleware_home_dir => $fmw_domain::middleware_home_dir,
    java_home_dir       => $fmw_domain::java_home_dir,
  }

  fmw_domain_nodemanager_service{"start nodemanager for ${bin_dir}":
    ensure      => 'running',
    version     => $fmw_domain::version,
    domain_name => $fmw_domain::domain_name,
    require     => Fmw_domain_add_nodemanager["Add nodemanager for ${bin_dir}"],
  }
}
