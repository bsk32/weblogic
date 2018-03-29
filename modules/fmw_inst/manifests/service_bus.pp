#
# fmw_inst::service_bus
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::service_bus(
  $source_file   = undef,
)
{
  require fmw_inst

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_wls::install

  if $fmw_inst::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {

    $fmw_template = 'fmw_12c.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/osb/bin"
    $option_array = []
    $fmw_install_type = 'Service Bus'

    if $fmw_inst::version == '12.1.3' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/service_bus/fmw_12.1.3.0.0_osb.jar"
    } elsif $fmw_inst::version == '12.2.1' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/service_bus/fmw_12.2.1.0.0_osb.jar"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/service_bus/fmw_${fmw_inst::version}.0_osb.jar"
    }
    $create_file1 = $fmw_installer_file

  } elsif $fmw_inst::version == '10.3.6' {

    $fmw_template = 'fmw_11g.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/Oracle_OSB1"
    $fmw_install_type = ''
    $option_array = ['TYPICAL TYPE=false',
                    'CUSTOM TYPE=true',
                    'Oracle Service Bus Examples=false',
                    'Oracle Service Bus IDE=false',
                    "WL_HOME=${fmw_inst::middleware_home_dir}/wlserver_10.3"]

    if $::kernel == 'windows'{
      $fmw_installer_file = "${fmw_inst::tmp_dir}/service_bus/Disk1/setup.exe"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/service_bus/Disk1/runInstaller"
    }
    $create_file1 = "${fmw_inst::tmp_dir}/service_bus/Disk1"
  }

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_wls::tmp_dir}/sb_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      mode    => '0755',
      owner   => $fmw_inst::os_user,
      group   => $fmw_inst::os_group,
      backup  => false,
    }

    if $fmw_inst::version in [ '12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '10.3.6' ] {
      fmw_inst::internal::fmw_extract{'service_bus':
        source_file       => $source_file,
        create_file_check => $create_file1,
        os_user           => $fmw_inst::os_user,
        os_group          => $fmw_inst::os_group,
        tmp_dir           => $fmw_inst::tmp_dir,
        before            => Fmw_inst::Internal::Fmw_install_linux['service_bus'],
      }
    }

    fmw_inst::internal::fmw_install_linux{'service_bus':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/sb_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      orainst_dir     => $fmw_inst::orainst_dir,
      os_user         => $fmw_inst::os_user,
      os_group        => $fmw_inst::os_group,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/sb_${fmw_template}"],
    }

  } elsif $::kernel in ['windows'] {
    file { "${fmw_wls::tmp_dir}/sb_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      backup  => false,
    }

    if $fmw_inst::version in [ '12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '10.3.6' ] {
      fmw_inst::internal::fmw_extract_windows{'service_bus':
        version             => $fmw_inst::version,
        middleware_home_dir => $fmw_inst::middleware_home_dir,
        source_file         => $source_file,
        create_file_check   => $create_file1,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_windows['service_bus'],
      }
    }

    fmw_inst::internal::fmw_install_windows{'service_bus':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/sb_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/sb_${fmw_template}"],
    }
  }
}
