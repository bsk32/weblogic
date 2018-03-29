#
# fmw_bsu::params
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_bsu::params()
{
  $version       = '12.1.3' # 10.3.6|12.1.1

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

}
