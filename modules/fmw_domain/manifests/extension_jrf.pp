#
# fmw_domain::extension_jrf
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::extension_jrf()
{
  require fmw_domain::domain

  $check = 'em.ear'

  if $fmw_domain::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '12.1.2'] {

    if $fmw_domain::version ==  '12.1.2' {
      $restricted       = false
      $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_jrf_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template_12.1.2.jar"
    }
    elsif $fmw_domain::version ==  '12.1.3' {
      $restricted       = false
      $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_jrf_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template_12.1.3.jar"
    }
    else {
      if $fmw_domain::restricted == true {
        $restricted       = true
        $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_restricted_template.jar"
        $wls_jrf_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_restricted_template.jar"
      }
      else {
        $restricted       = false
        $wls_em_template  = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
        $wls_jrf_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.jrf_template.jar"
      }
    }
  }
  elsif $fmw_domain::version == '10.3.6' {
    $restricted       = false
    $wls_em_template  = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
    $wls_jrf_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/jrf_template_11.1.1.jar"
  }

  $domain_name                   = $fmw_domain::domain_name
  $adminserver_name              = $fmw_domain::adminserver_name
  $adminserver_listen_address    = $fmw_domain::adminserver_listen_address
  $version                       = $fmw_domain::version

  $repository_database_url       = $fmw_domain::repository_database_url
  $repository_prefix             = $fmw_domain::repository_prefix

  if $::kernel in ['Linux', 'SunOS'] {

    $domain_path       = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"
    $weblogic_home_dir = $fmw_domain::weblogic_home_dir
    $java_home_dir     = $fmw_domain::java_home_dir
    $domain_dir        = $domain_path
    $app_dir           = "${fmw_domain::apps_dir}/${fmw_domain::domain_name}"
    $tmp_dir           = $fmw_domain::tmp_dir

    file { "${fmw_domain::tmp_dir}/jrf.py":
      ensure  => present,
      content => template('fmw_domain/domain/extensions/jrf.py'),
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

    # add JRF
    fmw_domain_wlst{'WLST add jrf':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/jrf.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      os_user             => $fmw_domain::os_user,
      require             => File["${fmw_domain::tmp_dir}/jrf.py",$fmw_domain::apps_dir],
    }


  } elsif $::kernel in ['windows'] {

    $domain_path       = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")
    $weblogic_home_dir = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir     = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $domain_dir        = $domain_path
    $app_dir           = fmw_domain_replace_slash("${fmw_domain::apps_dir}/${fmw_domain::domain_name}")
    $tmp_dir           = fmw_domain_replace_slash($fmw_domain::tmp_dir)

    file { "${fmw_domain::tmp_dir}/jrf.py":
      ensure             => present,
      content            => template('fmw_domain/domain/extensions/jrf.py'),
      source_permissions => ignore,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
      }
    }

    # add jrf
    fmw_domain_wlst{'WLST add jrf':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/jrf.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/jrf.py",$fmw_domain::apps_dir],
    }

  }

}