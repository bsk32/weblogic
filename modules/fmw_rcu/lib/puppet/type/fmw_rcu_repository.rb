# default puppet module level
module Puppet
  Type::newtype(:fmw_rcu_repository) do
    desc 'This is the Oracle WebLogic RCU ( Repository creation utility) installer type'

    newproperty(:ensure) do
      desc 'Whether a Repository should be created.'

      newvalue(:present, :event => :rcu_installed) do
        provider.install
      end

      newvalue(:absent, :event => :rcu_absent) do
        provider.drop
      end

      aliasvalue(:create, :present)
      aliasvalue(:delete, :absent)

      def retrieve
        provider.status
      end
    end

    newparam(:name) do
      desc <<-EOT
        The prefix of the RCU.
      EOT
      isnamevar
    end

    newparam(:os_user) do
      desc <<-EOT
        The weblogic operating system user.
      EOT
    end

    newparam(:os_group) do
      desc <<-EOT
        The weblogic operating system group.
      EOT
    end

    newparam(:oracle_home_dir) do
      desc <<-EOT
        The oracle home folder.
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

    newparam(:tmp_dir) do
      desc <<-EOT
        The temp folder.
      EOT
    end

    newparam(:version) do
      desc <<-EOT
        weblogic version.
      EOT
    end

    newparam(:jdbc_connect_url) do
      desc <<-EOT
        full JDBC connect url
      EOT
    end

    newparam(:db_connect_url) do
      desc <<-EOT
        rcu connect url
      EOT
    end

    newparam(:db_connect_user) do
      desc <<-EOT
        The database rcu sys user.
      EOT
    end

    newparam(:db_connect_password) do
      desc <<-EOT
        The database password of the rcu sys user.
      EOT
    end

    newparam(:rcu_components) do
      desc <<-EOT
        rcu components.
      EOT
    end

    newparam(:rcu_component_password) do
      desc <<-EOT
        The RCU database component password.
      EOT
    end

  end
end
