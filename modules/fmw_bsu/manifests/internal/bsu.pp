#
# fmw_bsu::internal::bsu
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_bsu::internal::bsu(
  $version             = $fmw_bsu::params::version,
  $middleware_home_dir = $fmw_bsu::params::middleware_home_dir,
  $patch_id            = undef,
  $source_file         = undef,
  $os_user             = $fmw_bsu::params::os_user,
  $os_group            = $fmw_bsu::params::os_group,
  $tmp_dir             = $fmw_bsu::params::tmp_dir,
)
{
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'

  file { "${middleware_home_dir}/utils/bsu/cache_dir":
    ensure => directory,
    mode   => '0775',
    owner  => $os_user,
    group  => $os_group,
  }

  if !defined(Package['unzip']) {
    package{ 'unzip':
      ensure => present,
    }
  }

  exec{ "extract ${patch_id}":
    command => "unzip -o ${source_file} -d ${middleware_home_dir}/utils/bsu/cache_dir",
    creates => "${middleware_home_dir}/utils/bsu/cache_dir/${patch_id}.jar",
    user    => $os_user,
    group   => $os_group,
    cwd     => $tmp_dir,
    path    => $path,
    timeout => 0,
    require => [File["${middleware_home_dir}/utils/bsu/cache_dir"],Package['unzip'],],
  }

  $bsu_utility = "${middleware_home_dir}/utils/bsu/bsu.sh"

  # have to do like this because of sed on solaris
  exec{ 'patch bsu.sh':
    command => "sed -e's/MEM_ARGS=\"-Xms256m -Xmx512m\"/MEM_ARGS=\"-Xms512m -Xmx752m -XX:-UseGCOverheadLimit\"/g' ${bsu_utility} > ${bsu_utility}.tmp && mv ${bsu_utility}.tmp ${bsu_utility}",
    unless  => "grep 'MEM_ARGS=\"-Xms512m -Xmx752m -XX:-UseGCOverheadLimit\"' ${bsu_utility}",
    user    => $os_user,
    group   => $os_group,
    path    => $path,
  }

  file { $bsu_utility:
    ensure  => present,
    mode    => '0755',
    owner   => $os_user,
    group   => $os_group,
    require => Exec['patch bsu.sh'],
  }

  if $version == '10.3.6' {
    $weblogic_home_dir = "${middleware_home_dir}/wlserver_10.3"
  } else {
    $weblogic_home_dir = "${middleware_home_dir}/wlserver_12.1"
  }

  fmw_bsu_patch { $patch_id:
    ensure              => 'present',
    os_user             => $os_user,
    middleware_home_dir => $middleware_home_dir,
    weblogic_home_dir   => $weblogic_home_dir,
    require             => [Exec["extract ${patch_id}",'patch bsu.sh'],File[$bsu_utility]],
  }
}