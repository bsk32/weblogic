require 'spec_helper'

describe 'fmw_domain::nodemanager', :type => :class do

  describe 'linux 1036' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '10.3.6',
            middleware_home_dir => '/opt/oracle/middleware_1036'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/wls1036_generic.jar',
          }

          class { 'fmw_domain':
            version                       => '10.3.6',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware',
            weblogic_home_dir             => '/opt/oracle/middleware/wlserver_10.3',
            domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 11g" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}


      it  { should contain_file('/opt/oracle/middleware/wlserver_10.3/common/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/etc/init.d/nodemanager_11g').with(
                      ensure:             'present',
                      mode:               '0755'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_redhat').with(
                  script_name:   'nodemanager_11g',
                 ).that_requires("File[/opt/oracle/middleware/wlserver_10.3/common/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_11g]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_11g').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             3,
                  nodemanager_port:   5556,

                 )
      }

    end

  end

  describe 'linux 1213' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
          }

          class { 'fmw_domain':
            version                       => '12.1.3',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware_1213',
            weblogic_home_dir             => '/opt/oracle/middleware_1213/wlserver',
            domains_dir                   => '/opt/oracle/middleware_1213/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware_1213/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/etc/init.d/nodemanager_base_xxx').with(
                      ensure:             'present',
                      mode:               '0755'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_redhat').with(
                  script_name:   'nodemanager_base_xxx',
                 ).that_requires("File[/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_base_xxx]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_base_xxx').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             3,
                  nodemanager_port:   5556,

                 )
      }

    end

  end

  describe 'debian 1213' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
          }

          class { 'fmw_domain':
            version                       => '12.1.3',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware_1213',
            weblogic_home_dir             => '/opt/oracle/middleware_1213/wlserver',
            domains_dir                   => '/opt/oracle/middleware_1213/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware_1213/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'Debian',
                     :osfamily        => 'Debian' }}

      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/etc/init.d/nodemanager_base_xxx').with(
                      ensure:             'present',
                      mode:               '0755'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_debian').with(
                  script_name:   'nodemanager_base_xxx',
                 ).that_requires("File[/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_base_xxx]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_base_xxx').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             3,
                  nodemanager_port:   5556,

                 )
      }

    end

  end


  describe 'redhat7 1213' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
          }

          class { 'fmw_domain':
            version                       => '12.1.3',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware_1213',
            weblogic_home_dir             => '/opt/oracle/middleware_1213/wlserver',
            domains_dir                   => '/opt/oracle/middleware_1213/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware_1213/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel                    => 'Linux',
                     :operatingsystem           => 'CentOS',
                     :osfamily                  => 'RedHat',
                     :operatingsystemmajrelease => '7' }}

      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/home/oracle/nodemanager_base_xxx').with(
                      ensure:             'present',
                      mode:               '0755'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_redhat_7').with(
                  script_name:   'nodemanager_base_xxx',
                 ).that_requires("File[/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_base_xxx]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_base_xxx').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             3,
                  nodemanager_port:   5556,

                 )
      }

    end

  end

  describe 'solaris 1036' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '10.3.6',
            middleware_home_dir => '/opt/oracle/middleware_1036'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/wls1036_generic.jar',
          }

          class { 'fmw_domain':
            version                       => '10.3.6',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware',
            weblogic_home_dir             => '/opt/oracle/middleware/wlserver_10.3',
            domains_dir                   => '/opt/oracle/middleware/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 11g" do

      let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}

      it  { should contain_file('/opt/oracle/middleware/wlserver_10.3/common/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_solaris').with(
                  script_name:   'nodemanager_11g',
                  nodemanager_bin_path: '/opt/oracle/middleware/wlserver_10.3/server/bin',
                 ).that_requires("File[/opt/oracle/middleware/wlserver_10.3/common/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_11g]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_11g').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             0,
                  nodemanager_port:   5556,

                 )
      }

    end

  end

  describe 'solaris 1213' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/fmw_12.1.3.0.0_wls.jar',
          }

          class { 'fmw_domain':
            version                       => '12.1.3',
            java_home_dir                 => '/usr/java/jdk1.7.0_75',
            middleware_home_dir           => '/opt/oracle/middleware_1213',
            weblogic_home_dir             => '/opt/oracle/middleware_1213/wlserver',
            domains_dir                   => '/opt/oracle/middleware_1213/user_projects/domains',
            apps_dir                      => '/opt/oracle/middleware_1213/user_projects/applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 1213" do

      let(:facts) {{ operatingsystem:           'Solaris',
                   kernel:                    'SunOS',
                   osfamily:                  'Solaris',
                   operatingsystemmajrelease: '11',
                   architecture:              'i86pc' }}


      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_solaris').with(
                  script_name:   'nodemanager_base_xxx',
                  nodemanager_bin_path: '/opt/oracle/middleware_1213/user_projects/domains/base_xxx/bin',
                 ).that_requires("File[/opt/oracle/middleware_1213/user_projects/domains/base_xxx/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_base_xxx]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_base_xxx').with(
                  ensure:             'running',
                  command:            'netstat -an | grep LISTEN',
                  column:             0,
                  nodemanager_port:   5556,
                 )
      }

    end

  end

  describe 'windows 1036' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => 'c:\\java\\jdk1.7.0_75',
            source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
          }

          class { 'fmw_wls':
            version             => '10.3.6',
            middleware_home_dir => 'C:\\Oracle\\middleware_1036'
          }

          class { 'fmw_wls::install':
            java_home_dir => 'c:\\java\\jdk1.7.0_75',
            source_file   => 'c:\\software\\wls1036_generic.jar',
          }

          class { 'fmw_domain':
            version                       => '10.3.6',
            java_home_dir                 => 'c:\\java\\jdk1.7.0_75',
            middleware_home_dir           => 'C:\\Oracle\\middleware_1036',
            weblogic_home_dir             => 'C:\\Oracle\\middleware_1036\\wlserver_10.3',
            domains_dir                   => 'C:\\Oracle\\middleware_1036\\user_projects\\domains',
            apps_dir                      => 'C:\\Oracle\\middleware_1036\\user_projects\\applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 11g" do


      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}



      it  { 
      # Puppet::Util::Log.level = :debug
      # Puppet::Util::Log.newdestination(:console)

            should contain_file('C:\Oracle\middleware_1036\wlserver_10.3/common/nodemanager/nodemanager.properties').with(
                      ensure:             'present'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_windows').with(
                  bin_dir: 'C:\Oracle\middleware_1036\wlserver_10.3/server/bin',
                 ).that_requires("File[C:\\Oracle\\middleware_1036\\wlserver_10.3/common/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_11g]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_11g').with(
                  ensure:             'running',
                  command:            "C:\\Windows\\System32\\cmd.exe /c \"netstat -an |find /i \"listening\"\"",
                  column:             1,
                  nodemanager_port:   5556,
                 )
      }

    end

  end

  describe 'windows 1213' do

    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => 'c:\\java\\jdk1.7.0_75',
            source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => 'C:\\Oracle\\middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => 'c:\\java\\jdk1.7.0_75',
            source_file   => 'c:\\software\\fmw_12.1.3.0.0_wls.jar',
          }

          class { 'fmw_domain':
            version                       => '12.1.3',
            java_home_dir                 => 'c:\\java\\jdk1.7.0_75',
            middleware_home_dir           => 'C:\\Oracle\\middleware_1213',
            weblogic_home_dir             => 'C:\\Oracle\\middleware_1213\\wlserver',
            domains_dir                   => 'C:\\Oracle\\middleware_1213\\user_projects\\domains',
            apps_dir                      => 'C:\\Oracle\\middleware_1213\\user_projects\\applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { 
        # Puppet::Util::Log.level = :debug
        # Puppet::Util::Log.newdestination(:console)
        # notice ( "${nodemanager_home_dir}/nodemanager.properties")

        should contain_file('C:\Oracle\middleware_1213\user_projects\domains/base_xxx/nodemanager/nodemanager.properties').with(
                      ensure:             'present'
                    )
      }

      it  { should contain_class('fmw_domain::internal::nodemanager_service_windows').with(
                  bin_dir: 'C:\Oracle\middleware_1213\user_projects\domains/base_xxx/bin',
                 ).that_requires("File[C:\\Oracle\\middleware_1213\\user_projects\\domains/base_xxx/nodemanager/nodemanager.properties]")
                  .that_comes_before('Fmw_domain_nodemanager_status[nodemanager_base_xxx]')
      }

      it  { should contain_fmw_domain_nodemanager_status('nodemanager_base_xxx').with(
                  ensure:             'running',
                  command:            "C:\\Windows\\System32\\cmd.exe /c \"netstat -an |find /i \"listening\"\"",
                  column:             1,
                  nodemanager_port:   5556,
                 )
      }

    end

  end

end
