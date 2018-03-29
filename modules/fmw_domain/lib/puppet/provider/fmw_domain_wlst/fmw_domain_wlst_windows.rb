#
# fmw_domain_wlst_windows
#
# Copyright 2015 Oracle. All Rights Reserved
#
require 'helper'

Puppet::Type.type(:fmw_domain_wlst).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  include DomainHelper

  def self.instances
    []
  end

  def execute
    version             = resource[:version]
    script_file         = resource[:script_file]
    weblogic_home_dir   = resource[:weblogic_home_dir]
    weblogic_password   = resource[:weblogic_password]
    repository_password = resource[:repository_password]

    DomainHelper.wlst_execute_windows(version, script_file, weblogic_home_dir, weblogic_password, repository_password)

    Puppet.info 'fmw_domain_wlst done'
  end


end
