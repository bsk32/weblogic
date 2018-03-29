#
# fmw_domain_wlst
#
# Copyright 2015 Oracle. All Rights Reserved
#
module Puppet
  Type::newtype(:fmw_domain_wlst) do
    desc 'allows you to execute a WLST script'

    newproperty(:ensure) do
      desc 'Whether a WLST script should be executed'

      newvalue(:present) do
        provider.execute
      end

      def retrieve
        domain_dir = resource[:domain_dir]
        extension_check = resource[:extension_check]
        name = resource[:name]

        if File.exist?("#{domain_dir}/config/config.xml")
          Puppet.info "#{name} domain exists"
          if extension_check.to_s == ''
            Puppet.info "#{name} no domain extensions check"
            return :present
          else
            Puppet.info "#{name} domain extensions check"
            return :present if File.readlines("#{domain_dir}/config/config.xml").grep(/#{extension_check}/).size > 0
          end
        end
        :absent
      end
    end

    newparam(:name) do
      desc <<-EOT
        The name WLST action
      EOT
      isnamevar
    end

    newparam(:extension_check) do
      desc <<-EOT
        The domain extension check to see if extension is already applied.
      EOT
    end

    newparam(:domain_dir) do
      desc <<-EOT
        The weblogic domain directory.
      EOT
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:version) do
      desc <<-EOT
        The weblogic version.
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

    newparam(:script_file) do
      desc <<-EOT
        The WLST script location.
      EOT
    end

    newparam(:java_home_dir) do
      desc <<-EOT
        The java home folder.
      EOT
    end

    newparam(:weblogic_user) do
      desc <<-EOT
        The weblogic domain user.
      EOT
    end

    newparam(:weblogic_password) do
      desc <<-EOT
        The weblogic domain password.
      EOT

      defaultto 'xxx'

    end

    newparam(:repository_password) do
      desc <<-EOT
        The FMW repository_password password.
      EOT

      defaultto 'xxx'

    end

    newparam(:tmp_dir) do
      desc <<-EOT
        The tmp directory.
      EOT
    end

  end
end

