#
# fmw_opatch::weblogic
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_opatch::weblogic(
  $patch_id      = undef,
  $source_file   = undef,
)
{
  require fmw_opatch

  if ( $patch_id == undef or is_integer($patch_id) == false ) {
    fail('patch_id parameter cannot be empty and should be a number')
  }

  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_wls::install

  if $fmw_opatch::version in ['12.2.1', '12.2.1.1', '12.1.3', '12.1.2'] {
    $fmw_oracle_home        = $fmw_opatch::middleware_home_dir
    $oracle_common_home_dir = $fmw_opatch::middleware_home_dir
  } elsif $fmw_opatch::version == '10.3.6' {
    fail('use fmw_bsu to patch WebLogic 10.3 or 11g')
  }

  if $::kernel in ['Linux', 'SunOS'] {
    fmw_opatch::internal::fmw_extract{$patch_id:
      source_file => $source_file,
      os_user     => $fmw_opatch::os_user,
      os_group    => $fmw_opatch::os_group,
      tmp_dir     => $fmw_opatch::tmp_dir,
    }

    fmw_opatch_patch{ $patch_id:
      ensure          => 'present',
      java_home_dir   => $fmw_opatch::java_home_dir,
      oracle_home_dir => $fmw_oracle_home,
      tmp_dir         => $fmw_opatch::tmp_dir,
      orainst_dir     => $fmw_opatch::orainst_dir,
      os_user         => $fmw_opatch::os_user,
      require         => Fmw_opatch::Internal::Fmw_extract[$patch_id],
    }

  } elsif $::kernel in ['windows'] {
    fmw_opatch::internal::fmw_extract_windows{$patch_id:
      version             => $fmw_opatch::version,
      middleware_home_dir => $fmw_opatch::middleware_home_dir,
      source_file         => $source_file,
      tmp_dir             => $fmw_opatch::tmp_dir,
    }

    fmw_opatch_patch{ $patch_id:
      ensure                 => 'present',
      java_home_dir          => $fmw_opatch::java_home_dir,
      oracle_common_home_dir => $oracle_common_home_dir,
      oracle_home_dir        => $fmw_oracle_home,
      tmp_dir                => $fmw_opatch::tmp_dir,
      require                => Fmw_opatch::Internal::Fmw_extract_windows[$patch_id],
    }
  }
}
