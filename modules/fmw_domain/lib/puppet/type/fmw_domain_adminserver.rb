#
# fmw_domain_adminserver
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_domain_adminserver) do
    desc 'allows you to start the WebLogic Adminserver'

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

    newparam(:domain_dir) do
      desc <<-EOT
        full path to the weblogic domain directory.
      EOT
    end

    newparam(:domain_name) do
      desc <<-EOT
        The weblogic domain name.
      EOT
    end

    newparam(:adminserver_name) do
      desc <<-EOT
        The weblogic adminserver name.
      EOT
    end

    newparam(:weblogic_home_dir) do
      desc <<-EOT
        The weblogic home directory.
      EOT
    end

    newparam(:java_home_dir) do
      desc <<-EOT
        The java home directory.
      EOT
    end

    newparam(:weblogic_user) do
      desc <<-EOT
        The weblogic user.
      EOT
    end

    newparam(:weblogic_password) do
      desc <<-EOT
        The weblogic password.
      EOT
    end

    newparam(:nodemanager_listen_address) do
      desc <<-EOT
        The listen address of the nodemanager.
      EOT
    end

    newparam(:nodemanager_port) do
      desc <<-EOT
        The listen port of the nodemanager.
      EOT
    end

    newparam(:os_user) do
      desc <<-EOT
        The operating system user.
      EOT
    end

  end
end
