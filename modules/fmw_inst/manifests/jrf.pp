#
# fmw_inst::jrf
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::jrf(
  $source_file   = undef,
)
{
  require fmw_inst

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_wls::install

  if $fmw_inst::version == '10.3.6' {

    $fmw_template = 'fmw_11g.rsp'
    $fmw_oracle_home = "${fmw_inst::middleware_home_dir}/oracle_common"
    $fmw_install_type = ''
    $option_array = []

    if $::kernel == 'windows'{
      $fmw_installer_file = "${fmw_inst::tmp_dir}/jrf/Disk1/setup.exe"
    } else {
      $fmw_installer_file = "${fmw_inst::tmp_dir}/jrf/Disk1/runInstaller"
    }
    $create_file1 = "${fmw_inst::tmp_dir}/jrf/Disk1"
  } else {
    fail('This is only for version 10.3.6, for 12c please use fmw_wls::install with the infra option')
  }

  if $::kernel in ['Linux', 'SunOS'] {
    file { "${fmw_wls::tmp_dir}/jrf_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      mode    => '0755',
      owner   => $fmw_inst::os_user,
      group   => $fmw_inst::os_group,
      backup  => false,
    }

    fmw_inst::internal::fmw_extract{'jrf':
        source_file       => $source_file,
        create_file_check => $create_file1,
        os_user           => $fmw_inst::os_user,
        os_group          => $fmw_inst::os_group,
        tmp_dir           => $fmw_inst::tmp_dir,
        before            => Fmw_inst::Internal::Fmw_install_linux['jrf'],
    }

    fmw_inst::internal::fmw_install_linux{'jrf':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/jrf_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      orainst_dir     => $fmw_inst::orainst_dir,
      os_user         => $fmw_inst::os_user,
      os_group        => $fmw_inst::os_group,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/jrf_${fmw_template}"],
    }

  } elsif $::kernel in ['windows'] {
    file { "${fmw_wls::tmp_dir}/sb_${fmw_template}":
      ensure  => present,
      content => template("fmw_inst/${fmw_template}"),
      backup  => false,
    }

    fmw_inst::internal::fmw_extract_windows{'jrf':
      version             => $fmw_inst::version,
      middleware_home_dir => $fmw_inst::middleware_home_dir,
      source_file         => $source_file,
      create_file_check   => $create_file1,
      tmp_dir             => $fmw_inst::tmp_dir,
      before              => Fmw_inst::Internal::Fmw_install_windows['jrf'],
    }

    fmw_inst::internal::fmw_install_windows{'jrf':
      java_home_dir   => $fmw_inst::java_home_dir,
      installer_file  => $fmw_installer_file,
      rsp_file        => "${fmw_inst::tmp_dir}/jrf_${fmw_template}",
      version         => $fmw_inst::version,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_inst::tmp_dir,
      require         => File["${fmw_wls::tmp_dir}/jrf_${fmw_template}"],
    }
  }
}
