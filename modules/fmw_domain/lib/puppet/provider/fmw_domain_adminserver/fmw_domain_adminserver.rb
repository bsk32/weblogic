#
# fmw_domain_nodemanager_service
#
# Copyright 2015 Oracle. All Rights Reserved
#
require 'helper'

Puppet::Type.type(:fmw_domain_adminserver).provide(:posix) do
  confine :kernel => ['Linux', 'SunOS']
  defaultfor :kernel => ['Linux', 'SunOS']

  include DomainHelper

  def self.instances
    []
  end

  def start
    adminserver_name           = resource[:adminserver_name]
    weblogic_home_dir          = resource[:weblogic_home_dir]
    weblogic_user              = resource[:weblogic_user]
    weblogic_password          = resource[:weblogic_password]
    nodemanager_listen_address = resource[:nodemanager_listen_address]
    nodemanager_port           = resource[:nodemanager_port]
    domain_name                = resource[:domain_name]
    domain_dir                 = resource[:domain_dir]
    os_user                    = resource[:os_user]

    DomainHelper.server_control(os_user, adminserver_name, weblogic_home_dir, weblogic_user, weblogic_password, nodemanager_listen_address, nodemanager_port, domain_name, domain_dir, "nmStart(\"#{adminserver_name}\")", 'Successfully started server')

  end

  def status
    adminserver_name           = resource[:adminserver_name]
    weblogic_home_dir          = resource[:weblogic_home_dir]
    weblogic_user              = resource[:weblogic_user]
    weblogic_password          = resource[:weblogic_password]
    nodemanager_listen_address = resource[:nodemanager_listen_address]
    nodemanager_port           = resource[:nodemanager_port]
    domain_name                = resource[:domain_name]
    domain_dir                 = resource[:domain_dir]
    os_user                    = resource[:os_user]

    output = DomainHelper.server_status(os_user, adminserver_name, weblogic_home_dir, weblogic_user, weblogic_password, nodemanager_listen_address, nodemanager_port, domain_name, domain_dir)
    Puppet.info "#{adminserver_name} status output #{output}"

    output.each_line do |line|
      unless line.nil?
        if line.include? 'UNKNOWN'
          return :stopped
        end
        if line.include? 'RUNNING'
          return :running
        end
      end
    end
    :stopped
  end

end
