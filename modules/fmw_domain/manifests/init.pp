#
# fmw_domain
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain(
  $version                       = $fmw_domain::params::version,
  $java_home_dir                 = undef,
  $middleware_home_dir           = $fmw_domain::params::middleware_home_dir,
  $weblogic_home_dir             = undef,
  $os_user                       = $fmw_domain::params::os_user,
  $os_group                      = $fmw_domain::params::os_group,
  $user_home_dir                 = $fmw_domain::params::user_home_dir,
  $tmp_dir                       = $fmw_domain::params::tmp_dir,
  $nodemanager_listen_address    = undef,
  $nodemanager_port              = $fmw_domain::params::nodemanager_port,
  $domains_dir                   = $fmw_domain::params::domains_dir,
  $apps_dir                      = $fmw_domain::params::apps_dir,
  $domain_name                   = undef,
  $weblogic_user                 = $fmw_domain::params::weblogic_user,
  $weblogic_password             = undef,
  $adminserver_name              = $fmw_domain::params::adminserver_name,
  $adminserver_listen_address    = undef,
  $adminserver_listen_port       = $fmw_domain::params::adminserver_listen_port,
  $restricted                    = $fmw_domain::params::restricted,
  $enterprise_scheduler_cluster  = undef,
  $service_bus_cluster           = undef,
  $soa_suite_cluster             = undef,
  $soa_suite_install_type        = 'SOA Suite', #SOA Suite|BPM
  $bam_cluster                   = undef,
  $adminserver_startup_arguments = $fmw_domain::params::adminserver_startup_arguments,
  $osb_server_startup_arguments  = $fmw_domain::params::osb_server_startup_arguments,
  $soa_server_startup_arguments  = $fmw_domain::params::soa_server_startup_arguments,
  $bam_server_startup_arguments  = $fmw_domain::params::bam_server_startup_arguments,
  $ess_server_startup_arguments  = $fmw_domain::params::ess_server_startup_arguments,
  $repository_database_url       = undef,
  $repository_prefix             = undef,
  $repository_password           = undef,
) inherits fmw_domain::params {
}
