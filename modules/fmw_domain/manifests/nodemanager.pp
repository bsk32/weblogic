#
# fmw_domain::nodemanager
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::nodemanager()
{
  require fmw_domain::domain

  if $fmw_domain::version == '10.3.6' {
    $nodemanager_home_dir  = "${fmw_domain::weblogic_home_dir}/common/nodemanager"
    $bin_dir               = "${fmw_domain::weblogic_home_dir}/server/bin"
    $nodemanager_template  = 'nodemanager.properties_11g'
    $nodemanager_check     = $fmw_domain::weblogic_home_dir
    $script_name           = 'nodemanager_11g'
  } else {
    $nodemanager_home_dir  = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}/nodemanager"
    $bin_dir               = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}/bin"
    $nodemanager_template  = 'nodemanager.properties_12c'
    $nodemanager_check     = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"
    $script_name           = "nodemanager_${fmw_domain::domain_name}"
  }

  $nodemanager_log_file        = "${nodemanager_home_dir}/nodemanager.log"
  $nodemanager_lock_file       = "${nodemanager_home_dir}/nodemanager.log.lck"
  $nodemanager_secure_listener = true
  $nodemanager_address         = $fmw_domain::nodemanager_listen_address
  $nodemanager_port            = $fmw_domain::nodemanager_port
  $platform_family             = $::osfamily
  $version                     = $fmw_domain::version

  if $::kernel in ['Linux', 'SunOS'] {
    $weblogic_home_dir    = $fmw_domain::weblogic_home_dir
    $java_home_dir        = $fmw_domain::java_home_dir
    $nodemanager_log_dir  = $nodemanager_log_file
    $domain_dir           = "${fmw_domain::domains_dir}/${fmw_domain::domain_name}"

    file { "${nodemanager_home_dir}/nodemanager.properties":
      ensure  => present,
      content => template("fmw_domain/nodemanager/${nodemanager_template}"),
      mode    => '0755',
      owner   => $fmw_domain::os_user,
      group   => $fmw_domain::os_group,
    }
  } elsif $::kernel in ['windows'] {
    $weblogic_home_dir    = fmw_domain_replace_slash($fmw_domain::weblogic_home_dir)
    $java_home_dir        = fmw_domain_replace_slash($fmw_domain::java_home_dir)
    $nodemanager_log_dir  = fmw_domain_replace_slash($nodemanager_log_file)
    $domain_dir           = fmw_domain_replace_slash("${fmw_domain::domains_dir}/${fmw_domain::domain_name}")

    file { "${nodemanager_home_dir}/nodemanager.properties":
      ensure             => present,
      content            => template("fmw_domain/nodemanager/${nodemanager_template}"),
      source_permissions => ignore,
    }
  }

  if $::kernel in ['Linux'] {
    $netstat_cmd = 'netstat -an | grep LISTEN'
    $netstat_column = 3

    if ( $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' ) {
      $location = "${fmw_domain::user_home_dir}/${fmw_domain::os_user}/${script_name}"
    } else {
      $location = "/etc/init.d/${script_name}"
    }

    $nodemanager_bin_path = $bin_dir
    $os_user              = $fmw_domain::os_user

    # add linux script to the right location
    file { $location:
      ensure  => present,
      content => regsubst(template('fmw_domain/nodemanager/nodemanager'), '\r\n', "\n", 'EMG'),
      mode    => '0755',
    }

    if $::osfamily == 'Debian'  {
      class{'fmw_domain::internal::nodemanager_service_debian':
        script_name => $script_name,
        before      => Fmw_domain_nodemanager_status[$script_name],
        require     => File["${nodemanager_home_dir}/nodemanager.properties",$location],
      }
      contain fmw_domain::internal::nodemanager_service_debian
    } elsif $::osfamily == 'RedHat' {
      if $::operatingsystemmajrelease == '7' {
        class{'fmw_domain::internal::nodemanager_service_redhat_7':
          script_name => $script_name,
          before      => Fmw_domain_nodemanager_status[$script_name],
          require     => File["${nodemanager_home_dir}/nodemanager.properties",$location],
        }
        contain fmw_domain::internal::nodemanager_service_redhat_7
      }
      else {
        class{'fmw_domain::internal::nodemanager_service_redhat':
          script_name => $script_name,
          before      => Fmw_domain_nodemanager_status[$script_name],
          require     => File["${nodemanager_home_dir}/nodemanager.properties",$location],
        }
        contain fmw_domain::internal::nodemanager_service_redhat
      }
    }

  } elsif $::kernel in ['SunOS'] {
    $netstat_cmd = 'netstat -an | grep LISTEN'
    $netstat_column = 0

    class{'fmw_domain::internal::nodemanager_service_solaris':
      script_name          => $script_name,
      nodemanager_bin_path => $bin_dir,
      before               => Fmw_domain_nodemanager_status[$script_name],
      require              => File["${nodemanager_home_dir}/nodemanager.properties"],
    }
    contain fmw_domain::internal::nodemanager_service_solaris

  } elsif $::kernel in ['windows'] {
    $netstat_cmd = "C:\\Windows\\System32\\cmd.exe /c \"netstat -an |find /i \"listening\"\""
    $netstat_column = 1

    class{'fmw_domain::internal::nodemanager_service_windows':
      bin_dir => $bin_dir,
      before  => Fmw_domain_nodemanager_status[$script_name],
      require => File["${nodemanager_home_dir}/nodemanager.properties"],
    }
    contain fmw_domain::internal::nodemanager_service_windows
  }

  fmw_domain_nodemanager_status{$script_name:
    ensure           => 'running',
    command          => $netstat_cmd,
    column           => $netstat_column,
    nodemanager_port => $fmw_domain::nodemanager_port,
  }

}