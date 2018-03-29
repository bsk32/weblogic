#
# fmw_domain_add_nodemanager
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_domain_add_nodemanager) do
    desc 'allows you to add a WebLogic nodemanager on a Windows host'

    newproperty(:ensure) do
      desc 'Whether a WLST script should be executed'

      newvalue(:present) do
        provider.install
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

    newparam(:bin_dir) do
      desc <<-EOT
        The nodemanager script bin folder.
      EOT
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

    newparam(:domain_dir) do
      desc <<-EOT
        The weblogic domain directory.
      EOT
    end

    newparam(:middleware_home_dir) do
      desc <<-EOT
        The middleware home folder.
      EOT
    end

    newparam(:java_home_dir) do
      desc <<-EOT
        The java home folder.
      EOT
    end

  end
end

