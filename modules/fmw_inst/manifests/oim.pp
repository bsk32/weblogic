#
# fmw_inst::oim
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::oim(
  $install_type  = 'Typical',
  $source_file   = undef,
  $source_2_file = undef,
  $source_3_file = undef,
  $oim_version = undef
)
{
  require fmw_inst

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }
  if ( $source_2_file == undef or is_string($source_2_file) == false ) {
    fail('source_2_file parameter cannot be empty')
  }
  if ( $source_3_file == undef or is_string($source_3_file) == false ) {
    fail('source_3_file parameter cannot be empty')
  }
  if ( $oim_version == undef or is_string($oim_version)==false) {
    fail('oim_version cannot be empty')
  }

  require fmw_wls::install

  if $fmw_inst::oim_version in ['11.1.2'] {

    $fmw_template = 'fmw_11g.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/oim/bin"

    $option_array = ['APPSERVER_TYPE=WLS',
                    "APPSERVER_LOCATION=${fmw_inst::middleware_home_dir}"]

    if $install_type != undef {
        unless $install_type in ['Typical'] {
          fail('unknown oim__install_type please use Typical')
        }
        $fmw_install_type = $install_type
    } else {
      $fmw_install_type = 'Typical'
    }

    if $::kernel == 'windows'{
      $fmw_installer_file = "${fmw_inst::tmp_dir}/oim/Disk1/setup.exe"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/oim/Disk1/runInstaller"
    }

    $create_file1 = "${fmw_inst::tmp_dir}/oim/Disk1"
    $create_file2 = "${fmw_inst::tmp_dir}/oim/Disk2"
    $create_file3 = "${fmw_inst::tmp_dir}/oim/Disk3"

    if $::kernel in ['Linux', 'SunOS'] {
      file { "${fmw_wls::tmp_dir}/oim_${fmw_template}":
        ensure  => present,
        content => template("fmw_inst/${fmw_template}"),
        mode    => '0755',
        owner   => $fmw_inst::os_user,
        group   => $fmw_inst::os_group,
        backup  => false,
      }

      fmw_inst::internal::fmw_extract{'oim':
        source_file         => $source_file,
        source_2_file       => $source_2_file,
        source_3_file       => $source_3_file,
        create_file_check   => $create_file1,
        create_2_file_check => $create_file2,
        create_3_file_check => $create_file3,
        os_user             => $fmw_inst::os_user,
        os_group            => $fmw_inst::os_group,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_linux['oim'],
      }

      fmw_inst::internal::fmw_install_linux{'oim':
        java_home_dir   => $fmw_inst::java_home_dir,
        installer_file  => $fmw_installer_file,
        rsp_file        => "${fmw_inst::tmp_dir}/oim_${fmw_template}",
        version         => $fmw_inst::version,
        oracle_home_dir => $fmw_oracle_home,
        orainst_dir     => $fmw_inst::orainst_dir,
        os_user         => $fmw_inst::os_user,
        os_group        => $fmw_inst::os_group,
        tmp_dir         => $fmw_inst::tmp_dir,
        require         => File["${fmw_wls::tmp_dir}/oim_${fmw_template}"],
      }

    } elsif $::kernel in ['windows'] {

      file { "${fmw_wls::tmp_dir}/oim_${fmw_template}":
        ensure  => present,
        content => template("fmw_inst/${fmw_template}"),
        backup  => false,
      }

      fmw_inst::internal::fmw_extract_windows{'oim':
        version             => $fmw_inst::version,
        middleware_home_dir => $fmw_inst::middleware_home_dir,
        source_file         => $source_file,
        source_2_file       => $source_2_file,
        source_3_file       => $source_3_file,
        create_file_check   => $create_file1,
        create_2_file_check => $create_file2,
        tmp_dir             => $fmw_inst::tmp_dir,
        before              => Fmw_inst::Internal::Fmw_install_windows['oim'],
      }

      fmw_inst::internal::fmw_install_windows{'oim':
        java_home_dir   => $fmw_inst::java_home_dir,
        installer_file  => $fmw_installer_file,
        rsp_file        => "${fmw_inst::tmp_dir}/oim_${fmw_template}",
        version         => $fmw_inst::version,
        oracle_home_dir => $fmw_oracle_home,
        tmp_dir         => $fmw_inst::tmp_dir,
        require         => File["${fmw_wls::tmp_dir}/oim_${fmw_template}"],
      }
    }
  }
}
