#
# fmw_domain_nodemanager_service
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_domain_nodemanager_service) do
    desc 'allows you to start the WebLogic nodemanager service on a Windows host'

    newproperty(:ensure) do
      desc 'Whether a WLST script should be executed'

      newvalue(:running) do
        provider.start
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

    newparam(:version) do
      desc <<-EOT
        The weblogic version.
      EOT
    end

    newparam(:domain_name) do
      desc <<-EOT
        The weblogic domain name.
      EOT
    end

  end
end

