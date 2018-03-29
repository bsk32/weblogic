#
# fmw_domain::extension_enterprise_scheduler
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::extension_enterprise_scheduler()
{
  require fmw_domain::domain
  require fmw_inst::soa_suite

  if $fmw_domain::soa_suite_install_type != undef {
    unless $fmw_domain::soa_suite_install_type in ['BPM', 'SOA Suite'] {
      fail('unknown soa_suite_install_type please use BPM|SOA Suite')
    }
    if $fmw_domain::soa_suite_install_type == 'BPM' {
      $bpm_enabled = true
    } else {
      $bpm_enabled = false
    }
  } else {
    $bpm_enabled = false
  }

  if $fmw_domain::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {
    $check = 'oracle.ess.runtime'

    if $fmw_domain::version ==  '12.1.3' {
      $wls_em_template     = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_ess_em_template = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_ess_template_12.1.3.jar"
      $wls_ess_template    = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.ess.basic_template_12.1.3.jar"
    }
    else {
      $wls_em_template     = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
      $wls_ess_em_template = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_ess_template.jar"
      $wls_ess_template    = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.ess.basic_template.jar"
    }
  }
  elsif $fmw_domain::version == '10.3.6' {
    fail('enterprise scheduler is not available on FMW 11g')
  }

  $domain_name                   = $fmw_domain::domain_name
  $adminserver_name              = $fmw_domain::adminserver_name
  $adminserver_listen_address    = $fmw_domain::adminserver_listen_address
  $version                       = $fmw_domain::version

  $ess_server_startup_arguments  = $fmw_domain::ess_server_startup_arguments
  $bam_cluster                   = $fmw_domain::bam_cluster
  $osb_cluster                   = $fmw_domain::service_bus_cluster
  $ess_cluster                   = $fmw_domain::enterprise_scheduler_cluster
  $soa_cluster                   = $fmw_domain::soa_suite_cluster
  $repository_database_url       = $fmw_domain::repository_database_url
  $repository_prefix             = $fmw_domain::repository_prefix

  if $::kernel in ['Linux', 'SunOS'] {

    $domain_path       = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"
    $weblogic_home_dir = $fmw_domain::weblogic_home_dir
    $java_home_dir     = $fmw_domain::java_home_dir
    $domain_dir        = $domain_path
    $app_dir           = "${fmw_domain::apps_dir}/${fmw_domain::domain_name}"
    $tmp_dir           = $fmw_domain::tmp_dir

    file { "${fmw_domain::tmp_dir}/enterprise_scheduler.py":
      ensure  => present,
      content => template('fmw_domain/domain/extensions/enterprise_scheduler.py'),
      mode    => '0755',
      owner   => $fmw_domain::os_user,
      group   => $fmw_domain::os_group,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
        mode   => '0755',
        owner  => $fmw_domain::os_user,
        group  => $fmw_domain::os_group,
      }
    }

    # add enterprise scheduler
    fmw_domain_wlst{'WLST add enterprise_scheduler.py':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/enterprise_scheduler.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      os_user             => $fmw_domain::os_user,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/enterprise_scheduler.py",$fmw_domain::apps_dir],
    }


  } elsif $::kernel in ['windows'] {

    $domain_path       = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")
    $weblogic_home_dir = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir     = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $domain_dir        = $domain_path
    $app_dir           = fmw_domain_replace_slash("${fmw_domain::apps_dir}/${fmw_domain::domain_name}")
    $tmp_dir           = fmw_domain_replace_slash($fmw_domain::tmp_dir)

    file { "${fmw_domain::tmp_dir}/enterprise_scheduler.py":
      ensure             => present,
      content            => template('fmw_domain/domain/extensions/enterprise_scheduler.py'),
      source_permissions => ignore,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
      }
    }

    # add enterprise scheduler
    fmw_domain_wlst{'WLST add enterprise_scheduler.py':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/enterprise_scheduler.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/enterprise_scheduler.py",$fmw_domain::apps_dir],
    }

  }

}