#
# fmw_inst
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst(
  $version             = $fmw_inst::params::version,
  $oim_version         = $fmw_inst::params::oim_version,
  $java_home_dir       = undef,
  $middleware_home_dir = $fmw_inst::params::middleware_home_dir,
  $orainst_dir         = $fmw_inst::params::orainst_dir,
  $os_user             = $fmw_inst::params::os_user,
  $os_group            = $fmw_inst::params::os_group,
  $tmp_dir             = $fmw_inst::params::tmp_dir,
) inherits fmw_inst::params {
}
