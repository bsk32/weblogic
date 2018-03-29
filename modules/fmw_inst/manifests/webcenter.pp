#
# fmw_inst::webcenter
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::webcenter(
  $install_type  = 'Typical',
  $source_file   = undef,
  $source_2_file = undef,
)
{
  require fmw_inst

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_wls::install


  if $fmw_inst::version in ['12.2.1', '12.2.1.1', '12.2.1.2'] {

    $fmw_template = 'fmw_12c.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/wcportal"
    $option_array = []

    $fmw_install_type = 'WebCenter Portal'
    if $fmw_inst::version == '12.2.1' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/webcenter/fmw_12.2.1.0.0_wcportal_generic.jar"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/webcenter/fmw_${fmw_inst::version}.0_wcportal_generic.jar"
    }
    $create_file1 = $fmw_installer_file
    $create_file2 = undef

  } elsif $fmw_inst::version == '10.3.6' {

    if ( $source_2_file == undef or is_string($source_2_file) == false ) {
      fail('source_2_file parameter cannot be empty')
    }

    $fmw_template = 'fmw_11g.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/Oracle_WC1"
    $fmw_install_type = ''
    $option_array = ['APPSERVER_TYPE=WLS',
                    "APPSERVER_LOCATION=${fmw_inst::middleware_home_dir}"]

    if $::kernel == 'windows'{
      $fmw_installer_file = "${fmw_inst::tmp_dir}/webcenter/Disk1/setup.exe"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/webcenter/Disk1/runInstaller"
    }
    $create_file1 = "${fmw_inst::tmp_dir}/webcenter/Disk1"
    $create_file2 = "${fmw_inst::tmp_dir}/webcenter/Disk4"
  }

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_wls::tmp_dir}/webcenter_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      mode    => '0755',
      owner   => $fmw_inst::os_user,
      group   => $fmw_inst::os_group,
      backup  => false,
    }

    fmw_inst::internal::fmw_extract{'webcenter':
      source_file         => $source_file,
      source_2_file       => $source_2_file,
      create_file_check   => $create_file1,
      create_2_file_check => $create_file2,
      os_user             => $fmw_inst::os_user,
      os_group            => $fmw_inst::os_group,
      tmp_dir             => $fmw_inst::tmp_dir,
    }

    fmw_inst::internal::fmw_install_linux{'webcenter':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/webcenter_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      orainst_dir     => $fmw_inst::orainst_dir,
      os_user         => $fmw_inst::os_user,
      os_group        => $fmw_inst::os_group,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => [Fmw_inst::Internal::Fmw_extract['webcenter'],File["${fmw_wls::tmp_dir}/webcenter_${fmw_template}"],],
    }

  } elsif $::kernel in ['windows'] {

    file { "${fmw_wls::tmp_dir}/webcenter_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      backup  => false,
    }

    fmw_inst::internal::fmw_extract_windows{'webcenter':
      version             => $fmw_inst::version,
      middleware_home_dir => $fmw_inst::middleware_home_dir,
      source_file         => $source_file,
      source_2_file       => $source_2_file,
      create_file_check   => $create_file1,
      create_2_file_check => $create_file2,
      tmp_dir             => $fmw_inst::tmp_dir,
    }

    fmw_inst::internal::fmw_install_windows{'webcenter':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/webcenter_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => [Fmw_inst::Internal::Fmw_extract_windows['webcenter'],File["${fmw_wls::tmp_dir}/webcenter_${fmw_template}"],],
    }
  }

}
