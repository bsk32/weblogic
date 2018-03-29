#
# fmw_domain::extension_service_bus
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::extension_service_bus()
{
  require fmw_domain::domain
  require fmw_inst::service_bus

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
    $check = 'osb.em'

    if $fmw_domain::version ==  '12.1.3' {
      $wls_em_template = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template_12.1.3.jar"
      $wls_sb_template = "${fmw_domain::middleware_home_dir}/osb/common/templates/wls/oracle.osb_template_12.1.3.jar"
      $wls_ws_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-template_12.1.3.jar"
    }
    else {
      $wls_em_template = "${fmw_domain::middleware_home_dir}/em/common/templates/wls/oracle.em_wls_template.jar"
      $wls_sb_template = "${fmw_domain::middleware_home_dir}/osb/common/templates/wls/oracle.osb_template.jar"
      $wls_ws_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/wls/oracle.wls-webservice-template.jar"
    }
  }
  elsif $fmw_domain::version == '10.3.6' {
    $check = 'ALSB'

    $wls_em_template = "${fmw_domain::middleware_home_dir}/oracle_common/common/templates/applications/oracle.em_11_1_1_0_0_template.jar"
    $wls_sb_template = "${fmw_domain::middleware_home_dir}/Oracle_OSB1/common/templates/applications/wlsb.jar"
    $wls_ws_template = "${fmw_domain::weblogic_home_dir}/common/templates/applications/wls_webservice.jar"
  }

  $domain_name                   = $fmw_domain::domain_name
  $adminserver_name              = $fmw_domain::adminserver_name
  $adminserver_listen_address    = $fmw_domain::adminserver_listen_address
  $version                       = $fmw_domain::version

  $osb_server_startup_arguments  = $fmw_domain::osb_server_startup_arguments
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

    file { "${fmw_domain::tmp_dir}/service_bus.py":
      ensure  => present,
      content => template('fmw_domain/domain/extensions/service_bus.py'),
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
    fmw_domain_wlst{'WLST add service_bus':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/service_bus.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      os_user             => $fmw_domain::os_user,
      require             => File["${fmw_domain::tmp_dir}/service_bus.py",$fmw_domain::apps_dir],
    }

    $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

    if $fmw_domain::version == '10.3.6' {
      exec { 'change debugFlag':
        command => "sed -i -e's/debugFlag=\"true\"/debugFlag=\"false\"/g' ${domain_path}/bin/setDomainEnv.sh",
        onlyif  => "/bin/grep debugFlag=\"true\" ${domain_path}/bin/setDomainEnv.sh | /usr/bin/wc -l",
        require => Fmw_domain_wlst['WLST add service_bus'],
        path    => $path,
        user    => $fmw_domain::os_user,
        group   => $fmw_domain::os_group,
      }

      exec { 'change ALSB_DEBUG_FLAG':
        command => "sed -i -e's/ALSB_DEBUG_FLAG=\"true\"/ALSB_DEBUG_FLAG=\"false\"/g' ${domain_path}/bin/setDomainEnv.sh",
        onlyif  => "/bin/grep ALSB_DEBUG_FLAG=\"true\" ${domain_path}/bin/setDomainEnv.sh | /usr/bin/wc -l",
        require => [Fmw_domain_wlst['WLST add service_bus'],Exec['change debugFlag']],
        path    => $path,
        user    => $fmw_domain::os_user,
        group   => $fmw_domain::os_group,
      }

      exec { 'change DERBY_FLAG':
        command => "sed -i -e's/DERBY_FLAG=\"true\"/DERBY_FLAG=\"false\"/g' ${domain_path}/bin/setDomainEnv.sh",
        onlyif  => "/bin/grep DERBY_FLAG=\"true\" ${domain_path}/bin/setDomainEnv.sh | /usr/bin/wc -l",
        require => [Fmw_domain_wlst['WLST add service_bus'],Exec['change debugFlag','change ALSB_DEBUG_FLAG']],
        path    => $path,
        user    => $fmw_domain::os_user,
        group   => $fmw_domain::os_group,
      }
    }

  } elsif $::kernel in ['windows'] {

    $domain_path       = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")
    $weblogic_home_dir = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir     = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $domain_dir        = $domain_path
    $app_dir           = fmw_domain_replace_slash("${fmw_domain::apps_dir}/${fmw_domain::domain_name}")
    $tmp_dir           = fmw_domain_replace_slash($fmw_domain::tmp_dir)

    file { "${fmw_domain::tmp_dir}/service_bus.py":
      ensure             => present,
      content            => template('fmw_domain/domain/extensions/service_bus.py'),
      source_permissions => ignore,
    }

    if !defined(File[$fmw_domain::apps_dir]) {
      file { $fmw_domain::apps_dir:
        ensure => directory,
      }
    }

    # add service bus
    fmw_domain_wlst{'WLST add service_bus':
      ensure              => 'present',
      version             => $fmw_domain::version,
      extension_check     => $check,
      script_file         => "${fmw_domain::tmp_dir}/service_bus.py",
      middleware_home_dir => $fmw_domain::middleware_home_dir,
      weblogic_home_dir   => $fmw_domain::weblogic_home_dir,
      java_home_dir       => $fmw_domain::java_home_dir,
      tmp_dir             => $fmw_domain::tmp_dir,
      domain_dir          => $domain_dir,
      repository_password => $fmw_domain::repository_password,
      require             => File["${fmw_domain::tmp_dir}/service_bus.py",$fmw_domain::apps_dir],
    }

    if $fmw_domain::version == '10.3.6' {
      exec { 'change ALSB_DEBUG_FLAG':
        command   => "\$c = Get-Content ${domain_path}/bin/setDomainEnv.cmd; \$c | %{\$_ -replace 'set ALSB_DEBUG_FLAG=true','set ALSB_DEBUG_FLAG=false'} | Set-Content ${domain_path}/bin/setDomainEnv.cmd",
        onlyif    => "if ((Get-Content ${domain_path}/bin/setDomainEnv.cmd) -match 'set ALSB_DEBUG_FLAG=true') { exit 0 } else { exit 1}",
        require   => Fmw_domain_wlst['WLST add service_bus'],
        provider  => powershell,
        logoutput => true,
      }
      exec { 'change debugFlag':
        command   => "\$c = Get-Content ${domain_path}/bin/setDomainEnv.cmd; \$c | %{\$_ -replace 'set debugFlag=true','set debugFlag=false'} | Set-Content ${domain_path}/bin/setDomainEnv.cmd",
        onlyif    => "if ((Get-Content ${domain_path}/bin/setDomainEnv.cmd) -match 'set debugFlag=true') { exit 0 } else { exit 1}",
        require   => [Fmw_domain_wlst['WLST add service_bus'],Exec['change ALSB_DEBUG_FLAG']],
        provider  => powershell,
        logoutput => true,
      }
      exec { 'change DERBY_FLAG':
        command   => "\$c = Get-Content ${domain_path}/bin/setDomainEnv.cmd; \$c | %{\$_ -replace 'set DERBY_FLAG=true','set DERBY_FLAG=false'} | Set-Content ${domain_path}/bin/setDomainEnv.cmd",
        onlyif    => "if ((Get-Content ${domain_path}/bin/setDomainEnv.cmd) -match 'set DERBY_FLAG=true') { exit 0 } else { exit 1}",
        require   => [Fmw_domain_wlst['WLST add service_bus'],Exec['change ALSB_DEBUG_FLAG','change debugFlag']],
        provider  => powershell,
        logoutput => true,
      }
    }

  }

}