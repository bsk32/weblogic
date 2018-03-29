#
# fmw_domain::extension_soa_suite
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::extension_soa_suite(
  $soa_suite_install_type = 'SOA Suite', #SOA Suite|BPM
)
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
    if $fmw_domain::version ==  '12.1.3' {
      $wls_em_template        = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_jrf_template       = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template_12.1.3.jar"
      $wls_appl_core_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.applcore.model.stub.1.0.0_template.jar"
      $wls_wsmpm_template     = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.wsmpm_template_12.1.3.jar"
      $wls_soa_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.soa_template_12.1.3.jar"
      $wls_bpm_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.bpm_template_12.1.3.jar"
      $wls_b2b_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.soa.b2b_template_12.1.3.jar"
    }
    else {
      $wls_em_template        = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
      $wls_jrf_template       = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template.jar"
      $wls_appl_core_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.applcore.model.stub_template.jar"
      $wls_wsmpm_template     = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.wsmpm_template.jar"
      $wls_soa_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.soa_template.jar"
      $wls_bpm_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.bpm_template.jar"
      $wls_b2b_template       = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.soa.b2b_template.jar"
    }
  }
  elsif $fmw_domain::version == '10.3.6' {
    $wls_em_template        = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
    $wls_jrf_template       = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
    $wls_appl_core_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.applcore.model.stub.11.1.1_template.jar"
    $wls_wsmpm_template     = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.wsmpm_template_11.1.1.jar"
    $wls_soa_template       = "${fmw_domain::middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.soa_template_11.1.1.jar"
    $wls_bpm_template       = "${fmw_domain::middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bpm_template_11.1.1.jar"
    $wls_b2b_template       = ''
  }

  $domain_name                   = $fmw_domain::domain_name
  $adminserver_name              = $fmw_domain::adminserver_name
  $adminserver_listen_address    = $fmw_domain::adminserver_listen_address
  $version                       = $fmw_domain::version

  $soa_server_startup_arguments  = $fmw_domain::soa_server_startup_arguments
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

    file { "${fmw_domain::tmp_dir}/soa_suite.py":
      ensure  => present,
      content => template('fmw_domain/domain/extensions/soa_suite.py'),
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

    # add SOA SUITE
    fmw_domain_wlst{'WLST add soa_suite':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => 'soa-infra',
      script_file         => "${fmw_domain::tmp_dir}/soa_suite.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      os_user             => $fmw_domain::os_user,
      require             => File["${fmw_domain::tmp_dir}/soa_suite.py",$fmw_domain::apps_dir],
    }

    if ( $fmw_domain::soa_suite_cluster != undef and $fmw_domain::version == '10.3.6' ) {
      # add soa_suite JMS cluster configuration
      fmw_domain_wlst{'WLST add soa_suite JMS cluster configuration':
        ensure              => 'present',
        version             => $fmw_domain::version,
        extension_check     => '<name>SOAJMSModuleUDDs</name>',
        script_file         => "${fmw_domain::middleware_home_dir}/Oracle_SOA1/bin/soa-createUDD.py --domain_home ${domain_path} --soacluster ${soa_cluster} --create_jms true",
        middleware_home_dir => $fmw_domain::middleware_home_dir,
        weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
        java_home_dir       => $fmw_domain::java_home_dir,
        tmp_dir             => $fmw_domain::tmp_dir,
        domain_dir          => $domain_dir,
        os_user             => $fmw_domain::os_user,
        require             => [Fmw_domain_wlst['WLST add soa_suite'],File["${fmw_domain::tmp_dir}/soa_suite.py",$fmw_domain::apps_dir],],
      }
    }

  } elsif $::kernel in ['windows'] {

    $domain_path       = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")
    $weblogic_home_dir = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir     = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $domain_dir        = $domain_path
    $app_dir           = fmw_domain_replace_slash("${fmw_domain::apps_dir}/${fmw_domain::domain_name}")
    $tmp_dir           = fmw_domain_replace_slash($fmw_domain::tmp_dir)

    file { "${fmw_domain::tmp_dir}/soa_suite.py":
      ensure             => present,
      content            => template('fmw_domain/domain/extensions/soa_suite.py'),
      source_permissions => ignore,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
      }
    }

    # add SOA SUITE
    fmw_domain_wlst{'WLST add soa_suite':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => 'soa-infra',
      script_file         => "${fmw_domain::tmp_dir}/soa_suite.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/soa_suite.py",$fmw_domain::apps_dir],
    }

    if ( $fmw_domain::soa_suite_cluster != undef and $fmw_domain::version == '10.3.6' ) {
      # add soa_suite JMS cluster configuration
      fmw_domain_wlst{'WLST add soa_suite JMS cluster configuration':
        ensure              => 'present',
        version             => $fmw_domain::version,
        extension_check     => '<name>SOAJMSModuleUDDs</name>',
        script_file         => "${fmw_domain::middleware_home_dir}/Oracle_SOA1/bin/soa-createUDD.py --domain_home ${domain_path} --soacluster ${soa_cluster} --create_jms true",
        middleware_home_dir => $fmw_domain::middleware_home_dir,
        weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
        java_home_dir       => $fmw_domain::java_home_dir,
        tmp_dir             => $fmw_domain::tmp_dir,
        domain_dir          => $domain_dir,
        require             => [Fmw_domain_wlst['WLST add soa_suite'],File["${fmw_domain::tmp_dir}/soa_suite.py",$fmw_domain::apps_dir],],
      }
    }
  }

}