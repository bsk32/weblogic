#
# fmw_inst::soa_suite
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::soa_suite(
  $install_type  = 'SOA Suite',
  $source_file   = undef,
  $source_2_file = undef,
)
{
  require fmw_inst

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_wls::install

  if $fmw_inst::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {

    $fmw_template = 'fmw_12c.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/soa/bin"
    $option_array = []

    if $install_type != undef {
        unless $install_type in ['BPM', 'SOA Suite'] {
          fail('unknown soa_suite_install_type please use BPM|SOA Suite')
        }
        $fmw_install_type = $install_type
    } else {
      $fmw_install_type = 'SOA Suite'
    }

    if $fmw_inst::version == '12.1.3' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/soa_suite/fmw_12.1.3.0.0_soa.jar"
    } elsif $fmw_inst::version == '12.2.1' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/soa_suite/fmw_12.2.1.0.0_soa.jar"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/soa_suite/fmw_${fmw_inst::version}.0_soa.jar"
    }
    $create_file1 = $fmw_installer_file
    $create_file2 = undef

  } elsif $fmw_inst::version == '10.3.6' {

    if ( $source_2_file == undef or is_string($source_2_file) == false ) {
      fail('source_2_file parameter cannot be empty')
    }

    $fmw_template = 'fmw_11g.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/Oracle_SOA1"
    $fmw_install_type = ''
    $option_array = ['APPSERVER_TYPE=WLS',
                    "APPSERVER_LOCATION=${fmw_inst::middleware_home_dir}"]

    if $::kernel == 'windows'{
      $fmw_installer_file = "${fmw_inst::tmp_dir}/soa_suite/Disk1/setup.exe"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/soa_suite/Disk1/runInstaller"
    }
    $create_file1 = "${fmw_inst::tmp_dir}/soa_suite/Disk1"
    $create_file2 = "${fmw_inst::tmp_dir}/soa_suite/Disk4"
  }

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_wls::tmp_dir}/soa_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      mode    => '0755',
      owner   => $fmw_inst::os_user,
      group   => $fmw_inst::os_group,
      backup  => false,
    }

    if $fmw_inst::version in [ '12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '10.3.6' ] {
      fmw_inst::internal::fmw_extract{'soa_suite':
        source_file         => $source_file,
        source_2_file       => $source_2_file,
        create_file_check   => $create_file1,
        create_2_file_check => $create_file2,
        os_user             => $fmw_inst::os_user,
        os_group            => $fmw_inst::os_group,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_linux['soa_suite'],
      }
    }

    fmw_inst::internal::fmw_install_linux{'soa_suite':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/soa_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      orainst_dir     => $fmw_inst::orainst_dir,
      os_user         => $fmw_inst::os_user,
      os_group        => $fmw_inst::os_group,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/soa_${fmw_template}"],
    }

  } elsif $::kernel in ['windows'] {

    file { "${fmw_wls::tmp_dir}/soa_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      backup  => false,
    }

    if $fmw_inst::version in [ '12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '10.3.6' ] {
      fmw_inst::internal::fmw_extract_windows{'soa_suite':
        version             => $fmw_inst::version,
        middleware_home_dir => $fmw_inst::middleware_home_dir,
        source_file         => $source_file,
        source_2_file       => $source_2_file,
        create_file_check   => $create_file1,
        create_2_file_check => $create_file2,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_windows['soa_suite'],
      }
    }

    fmw_inst::internal::fmw_install_windows{'soa_suite':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/soa_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/soa_${fmw_template}"],
    }
  }

}
