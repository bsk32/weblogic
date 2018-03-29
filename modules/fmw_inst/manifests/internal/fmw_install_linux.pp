#
# fmw_inst::internal::fmw_install_linux
#
# Copyright 2015 Oracle. All Rights Reserved
#
define fmw_inst::internal::fmw_install_linux(
  $java_home_dir   = undef,
  $installer_file  = undef,
  $rsp_file        = undef,
  $version         = undef,
  $oim_version     = undef,
  $oracle_home_dir = undef,
  $orainst_dir     = undef,
  $os_user         = undef,
  $os_group        = undef,
  $tmp_dir         = undef,
)
{
  if $version == '10.3.6' {
    exec{ "Install ${title}":
      command => "${installer_file} -silent -response ${rsp_file} -waitforcompletion -ignoreSysPrereqs -invPtrLoc ${orainst_dir}/oraInst.loc -jreLoc ${java_home_dir} -Djava.io.tmpdir=${tmp_dir}",
      creates => $oracle_home_dir,
      user    => $os_user,
      group   => $os_group,
      cwd     => $tmp_dir,
      timeout => 0,
    }
  } elsif $version in ['12.2.1', '12.2.1.1', '12.2.1.2', '12.1.3', '12.1.2'] {
    exec{ "Install ${title}":
      command => "${java_home_dir}/bin/java -Xmx1024m -Djava.io.tmpdir=${tmp_dir} -jar ${installer_file} -waitforcompletion -silent -responseFile ${rsp_file} -invPtrLoc ${orainst_dir}/oraInst.loc -jreLoc ${java_home_dir}",
      creates => $oracle_home_dir,
      user    => $os_user,
      group   => $os_group,
      cwd     => $tmp_dir,
      timeout => 0,
    }
  }
}
