#
# fmw_domain::extension_bam
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::extension_bam()
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
    $check = '<name>BamServer</name>'

    if $fmw_domain::version ==  '12.1.3' {
      $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_bam_template = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.bam.server_template_12.1.3.jar"
    }
    else {
      $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
      $wls_bam_template = "${fmw_domain::middleware_home_dir}/soa/common/templates/wls/oracle.bam.server_template.jar"
    }
  }
  elsif $fmw_domain::version == '10.3.6' {
    $check = 'oracle-bam#11.1.1'

    $wls_em_template  = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
    $wls_bam_template = "${fmw_domain::middleware_home_dir}/Oracle_SOA1/common/templates/applications/oracle.bam_template_11.1.1.jar"
  }

  $domain_name                   = $fmw_domain::domain_name
  $adminserver_name              = $fmw_domain::adminserver_name
  $adminserver_listen_address    = $fmw_domain::adminserver_listen_address
  $version                       = $fmw_domain::version

  $bam_server_startup_arguments  = $fmw_domain::bam_server_startup_arguments
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

    file { "${fmw_domain::tmp_dir}/bam.py":
      ensure  => present,
      content => template('fmw_domain/domain/extensions/bam.py'),
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
    fmw_domain_wlst{'WLST add bam':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/bam.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      os_user             => $fmw_domain::os_user,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/bam.py",$fmw_domain::apps_dir],
    }

    if ( $fmw_domain::bam_cluster != undef and $fmw_domain::version == '10.3.6' ) {
      # add bam JMS cluster configuration
      fmw_domain_wlst{'WLST add bam JMS cluster configuration':
        ensure              => 'present',
        version             => $fmw_domain::version,
        extension_check     => '<name>BAMJMSModuleUDDs</name>',
        script_file         => "${fmw_domain::middleware_home_dir}/Oracle_SOA1/bin/soa-createUDD.py --domain_home ${domain_path} --bamcluster ${bam_cluster} --create_jms true --extend=true",
        middleware_home_dir => $fmw_domain::middleware_home_dir,
        weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
        java_home_dir       => $fmw_domain::java_home_dir,
        tmp_dir             => $fmw_domain::tmp_dir,
        domain_dir          => $domain_dir,
        os_user             => $fmw_domain::os_user,
        require             => [Fmw_domain_wlst['WLST add bam'],File["${fmw_domain::tmp_dir}/bam.py",$fmw_domain::apps_dir],],
      }
    }

  } elsif $::kernel in ['windows'] {

    $domain_path       = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")
    $weblogic_home_dir = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir     = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $domain_dir        = $domain_path
    $app_dir           = fmw_domain_replace_slash("${fmw_domain::apps_dir}/${fmw_domain::domain_name}")
    $tmp_dir           = fmw_domain_replace_slash($fmw_domain::tmp_dir)

    file { "${fmw_domain::tmp_dir}/bam.py":
      ensure             => present,
      content            => template('fmw_domain/domain/extensions/bam.py'),
      source_permissions => ignore,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
      }
    }

    # add service bus
    fmw_domain_wlst{'WLST add bam':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/bam.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/bam.py",$fmw_domain::apps_dir],
    }

    if ( $fmw_domain::bam_cluster != undef and $fmw_domain::version == '10.3.6' ) {
      # add bam JMS cluster configuration
      fmw_domain_wlst{'WLST add bam JMS cluster configuration':
        ensure              => 'present',
        version             => $fmw_domain::version,
        extension_check     => '<name>BAMJMSModuleUDDs</name>',
        script_file         => "${fmw_domain::middleware_home_dir}/Oracle_SOA1/bin/soa-createUDD.py --domain_home ${domain_path} --bamcluster ${bam_cluster} --create_jms true --extend=true",
        middleware_home_dir => $fmw_domain::middleware_home_dir,
        weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
        java_home_dir       => $fmw_domain::java_home_dir,
        tmp_dir             => $fmw_domain::tmp_dir,
        domain_dir          => $domain_dir,
        require             => [Fmw_domain_wlst['WLST add bam'],File["${fmw_domain::tmp_dir}/bam.py",$fmw_domain::apps_dir],],
      }
    }
  }

}