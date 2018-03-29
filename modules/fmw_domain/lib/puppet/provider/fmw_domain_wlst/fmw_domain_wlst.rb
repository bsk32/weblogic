#
# fmw_domain_wlst
#
# Copyright 2015 Oracle. All Rights Reserved
#
require 'helper'

Puppet::Type.type(:fmw_domain_wlst).provide(:posix) do
  confine :kernel => ['Linux', 'SunOS']
  defaultfor :kernel => ['Linux', 'SunOS']

  include DomainHelper

  def self.instances
    []
  end

  def execute
    version             = resource[:version]
    os_user             = resource[:os_user]
    script_file         = resource[:script_file]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    weblogic_password   = resource[:weblogic_password]
    repository_password = resource[:repository_password]

    DomainHelper.wlst_execute(version, os_user, script_file, weblogic_home_dir, weblogic_password, repository_password)

    Puppet.info 'fmw_domain_wlst done'

  end

end
