#
# fmw_domain_nodemanager_status
#
# Copyright 2015 Oracle. All Rights Reserved
#
require 'helper'

Puppet::Type.type(:fmw_domain_nodemanager_status).provide(:fmw_domain_nodemanager_status) do

  include DomainHelper

  def self.instances
    []
  end

  def check
    netstat_cmd      = resource[:command]
    netstat_column   = resource[:column].to_i
    nodemanager_port = resource[:nodemanager_port].to_i

    i = 1
    until DomainHelper.listening?(netstat_cmd, nodemanager_port, netstat_column)
      Puppet.info "nodemanager not active yet (port #{nodemanager_port.to_s})"
      sleep 2
      i += 1
      fail 'nodemanager startup takes too long' if  i > 30
    end
  end

  def status
    netstat_cmd      = resource[:command]
    netstat_column   = resource[:column].to_i
    nodemanager_port = resource[:nodemanager_port].to_i

    if DomainHelper.listening?(netstat_cmd, nodemanager_port, netstat_column)
      return :running
    end
    :notactive
  end


end
