#
# fmw_inst::params
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_inst::params()
{
  $version       = '12.1.3' # 10.3.6|12.1.1|12.1.2|12.1.3|12.2.1|12.2.1.1|12.2.1.2
  $oim_version   = '11.1.2'

  $os_user       = 'oracle'
  $os_group      = 'oinstall'

  $middleware_home_dir = $::kernel? {
    'windows' => 'C:/oracle/middleware',
    default   => '/opt/oracle/middleware',
  }

  $tmp_dir = $::kernel? {
    'windows' => 'C:/temp',
    'SunOS'   => '/var/tmp',
    default   => '/tmp',
  }

  $orainst_dir = $::kernel? {
    'SunOS' => '/var/opt/oracle',
    default => '/etc',
  }

}
