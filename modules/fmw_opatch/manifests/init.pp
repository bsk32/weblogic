#
# fmw_opatch
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_opatch(
  $version             = $fmw_opatch::params::version,
  $java_home_dir       = undef,
  $middleware_home_dir = $fmw_opatch::params::middleware_home_dir,
  $orainst_dir         = $fmw_opatch::params::orainst_dir,
  $os_user             = $fmw_opatch::params::os_user,
  $os_group            = $fmw_opatch::params::os_group,
  $tmp_dir             = $fmw_opatch::params::tmp_dir,
) inherits fmw_opatch::params {
}