#
# fmw_bsu_patch
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_bsu_patch) do
    desc 'allows you to patch Oracle WebLogic 10.3.6 or 12.1.1'

    newproperty(:ensure) do
      desc 'Whether a patch should be applied.'

      newvalue(:present) do
        provider.install
      end

      def retrieve
        provider.status
      end
    end

    newparam(:name) do
      desc <<-EOT
        The name of the BSU WebLogic Patch.
      EOT
      isnamevar
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:middleware_home_dir) do
      desc <<-EOT
        The middleware home folder.
      EOT
    end

    newparam(:weblogic_home_dir) do
      desc <<-EOT
        The weblogic home folder.
      EOT
    end
  end
end
