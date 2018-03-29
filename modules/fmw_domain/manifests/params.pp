#
# fmw_domain::params
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_domain::params()
{
  $version       = '12.1.3' # 10.3.6|12.1.1|12.1.2|12.1.3|12.2.1|12.2.1.1|12.2.1.2

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

  $user_home_dir = $::kernel? {
    'Linux'  => '/home',
    'SunOS'  => '/export/home',
    default  => '/home',
  }

  $restricted = false

  $nodemanager_port = 5556

  $weblogic_user           = 'weblogic'
  $adminserver_name        = 'AdminServer'
  $adminserver_listen_port = 7001

  $domains_dir = $::kernel? {
    'windows' => 'C:/oracle/middleware/user_projects/domains',
    default   => '/opt/oracle/middleware/user_projects/domains',
  }

  $apps_dir = $::kernel? {
    'windows' => 'C:/oracle/middleware/user_projects/applications',
    default   => '/opt/oracle/middleware/user_projects/applications',
  }

  $adminserver_startup_arguments = $::kernel? {
    'Linux' => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom',
    default => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m',
  }

  $osb_server_startup_arguments = $::kernel? {
    'Linux' => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom',
    default => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m',
  }

  $soa_server_startup_arguments = $::kernel? {
    'Linux' => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom',
    default => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m',
  }

  $bam_server_startup_arguments = $::kernel? {
    'Linux' => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom',
    default => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m',
  }

  $ess_server_startup_arguments = $::kernel? {
    'Linux' => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m -Djava.security.egd=file:/dev/./urandom',
    default => '-XX:PermSize=256m -XX:MaxPermSize=512m -Xms1024m -Xmx1024m',
  }

}
