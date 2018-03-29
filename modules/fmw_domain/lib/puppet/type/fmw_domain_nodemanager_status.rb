#
# fmw_domain_nodemanager_status
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_domain_nodemanager_status) do
    desc 'allows you to check if the nodemanager is listening'

    newproperty(:ensure) do
      desc 'Whether a WLST script should be executed'

      newvalue(:running) do
        provider.check
      end

      def retrieve
        provider.status
      end

    end

    newparam(:name) do
      desc <<-EOT
        The service name
      EOT
      isnamevar
    end

    newparam(:command) do
      desc <<-EOT
        netstat command.
      EOT
    end

    newparam(:column) do
      desc <<-EOT
        netstat output column
      EOT
    end

    newparam(:nodemanager_port) do
      desc <<-EOT
        nodemanager port number
      EOT
    end

  end
end

