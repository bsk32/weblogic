#
# fmw_inst::mft
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::mft(
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
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/mft/bin"
    $option_array = []
    $fmw_install_type = 'Typical'

    if $fmw_inst::version == '12.1.3' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/mft/fmw_12.1.3.0.0_mft.jar"
    } elsif $fmw_inst::version == '12.2.1' {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/mft/fmw_12.2.1.0.0_mft.jar"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/mft/fmw_${fmw_inst::version}.0_mft.jar"
    }
    $create_file1 = $fmw_installer_file
  }

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_wls::tmp_dir}/mft_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      mode    => '0755',
      owner   => $fmw_inst::os_user,
      group   => $fmw_inst::os_group,
      backup  => false,
    }

    if $fmw_inst::version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3'] {
      fmw_inst::internal::fmw_extract{'mft':
        source_file       => $source_file,
        create_file_check => $create_file1,
        os_user           => $fmw_inst::os_user,
        os_group          => $fmw_inst::os_group,
        tmp_dir           => $fmw_inst::tmp_dir,
        before            => Fmw_inst::Internal::Fmw_install_linux['mft'],
      }
    }

    fmw_inst::internal::fmw_install_linux{'mft':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/mft_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      orainst_dir     => $fmw_inst::orainst_dir,
      os_user         => $fmw_inst::os_user,
      os_group        => $fmw_inst::os_group,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/mft_${fmw_template}"],
    }

  } elsif $::kernel in ['windows'] {

    file { "${fmw_wls::tmp_dir}/mft_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      backup  => false,
    }

    if $fmw_inst::version in [ '12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3' ] {
      fmw_inst::internal::fmw_extract_windows{'mft':
        version             => $fmw_inst::version,
        middleware_home_dir => $fmw_inst::middleware_home_dir,
        source_file         => $source_file,
        create_file_check   => $create_file1,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_windows['mft'],
      }
    }

    fmw_inst::internal::fmw_install_windows{'mft':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/mft_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/mft_${fmw_template}"],
    }
  }
}
