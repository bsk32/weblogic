#
# fmw_opatch_patch
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_opatch_patch) do
    desc 'allows you to patch Oracle WebLogic 12c or any 11g or 12c FMW products'

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
        The id of the OPatch.
      EOT
      isnamevar
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:oracle_home_dir) do
      desc <<-EOT
        The oracle home folder.
      EOT
    end

    newparam(:oracle_common_home_dir) do
      desc <<-EOT
        The oracle common home folder.
      EOT
    end

    newparam(:java_home_dir) do
      desc <<-EOT
        The java home folder.
      EOT
    end

    newparam(:orainst_dir) do
      desc <<-EOT
        The orainst folder.
      EOT
    end

    newparam(:tmp_dir) do
      desc <<-EOT
        The temp folder.
      EOT
    end
  end
end
