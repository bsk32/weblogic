require 'spec_helper'

describe 'fmw_domain::domain', :type => :class do

  describe 'unix 1036' do

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

       "
    end


    describe "domain 11g" do
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/common.py').with(
                      ensure:             'present',
                      source:             'puppet:///modules/fmw_domain/domain/common.py',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/tmp/domain.py').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      # it  { should contain_file('/opt/oracle/middleware/user_projects').with(
      #                 ensure:             'directory',
      #                 mode:               '0775',
      #                 owner:              'oracle',
      #                 group:              'oinstall',
      #               )
      # }

      it  { should contain_file('/opt/oracle/middleware/user_projects/domains').with(
                      ensure:             'directory',
                      mode:               '0775',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST create domain').with(
                      ensure:              'present',
                      os_user:             'oracle',
                      script_file:         '/tmp/domain.py',
                      middleware_home_dir: '/opt/oracle/middleware',
                      weblogic_home_dir:   '/opt/oracle/middleware/wlserver_10.3',
                      java_home_dir:       '/usr/java/jdk1.7.0_75',
                      tmp_dir:             '/tmp',
                      domain_dir:          '/opt/oracle/middleware/user_projects/domains/base_xxx',
                    ).that_requires("File[/opt/oracle/middleware/user_projects/domains]")
                     .that_requires("File[/tmp/domain.py]")
                     .that_requires("File[/tmp/common.py]")
      }

    end
  end

  describe 'unix 1213' do

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

       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/common.py').with(
                      ensure:             'present',
                      source:             'puppet:///modules/fmw_domain/domain/common.py',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/tmp/domain.py').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      # it  { should contain_file('/opt/oracle/middleware_1213/user_projects').with(
      #                 ensure:             'directory',
      #                 mode:               '0775',
      #                 owner:              'oracle',
      #                 group:              'oinstall',
      #               )
      # }

      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/domains').with(
                      ensure:             'directory',
                      mode:               '0775',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST create domain').with(
                      ensure:              'present',
                      os_user:             'oracle',
                      script_file:         '/tmp/domain.py',
                      middleware_home_dir: '/opt/oracle/middleware_1213',
                      weblogic_home_dir:   '/opt/oracle/middleware_1213/wlserver',
                      java_home_dir:       '/usr/java/jdk1.7.0_75',
                      tmp_dir:             '/tmp',
                      domain_dir:          '/opt/oracle/middleware_1213/user_projects/domains/base_xxx',
                    ).that_requires("File[/opt/oracle/middleware_1213/user_projects/domains]")
                     .that_requires("File[/tmp/domain.py]")
                     .that_requires("File[/tmp/common.py]")
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

       "
    end

    describe "wls 11g" do

      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}


      it  { should contain_file('C:/temp/common.py').with(
                      ensure:             'present',
                      source:             'puppet:///modules/fmw_domain/domain/common.py',
                    )
      }

      it  { should contain_file('C:/temp/domain.py').with(
                      ensure:             'present',
                    )
      }

      # it  { should contain_file('C:\\Oracle\\middleware_1213\\user_projects').with(
      #                 ensure:             'directory',
      #               )
      # }

      it  { should contain_file('C:\\Oracle\\middleware_1036\\user_projects\\domains').with(
                      ensure:             'directory',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST create domain').with(
                      ensure:              'present',
                      script_file:         'C:/temp/domain.py',
                      middleware_home_dir: 'C:\\Oracle\\middleware_1036',
                      weblogic_home_dir:   'C:\\Oracle\\middleware_1036\\wlserver_10.3',
                      java_home_dir:       'c:\\java\\jdk1.7.0_75',
                      tmp_dir:             'C:/temp',
                      domain_dir:          'C:\\Oracle\\middleware_1036\\user_projects\\domains/base_xxx',
                    ).that_requires("File[C:\\Oracle\\middleware_1036\\user_projects\\domains]")
                     .that_requires("File[C:/temp/domain.py]")
                     .that_requires("File[C:/temp/common.py]")
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

       "
    end

    describe "wls 1213" do

      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}


      it  { should contain_file('C:/temp/common.py').with(
                      ensure:             'present',
                      source:             'puppet:///modules/fmw_domain/domain/common.py',
                    )
      }

      it  { should contain_file('C:/temp/domain.py').with(
                      ensure:             'present',
                    )
      }

      # it  { should contain_file('C:\\Oracle\\middleware_1213\\user_projects').with(
      #                 ensure:             'directory',
      #               )
      # }

      it  { should contain_file('C:\\Oracle\\middleware_1213\\user_projects\\domains').with(
                      ensure:             'directory',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST create domain').with(
                      ensure:              'present',
                      script_file:         'C:/temp/domain.py',
                      middleware_home_dir: 'C:\\Oracle\\middleware_1213',
                      weblogic_home_dir:   'C:\\Oracle\\middleware_1213\\wlserver',
                      java_home_dir:       'c:\\java\\jdk1.7.0_75',
                      tmp_dir:             'C:/temp',
                      domain_dir:          'C:\\Oracle\\middleware_1213\\user_projects\\domains/base_xxx',
                    ).that_requires("File[C:\\Oracle\\middleware_1213\\user_projects\\domains]")
                     .that_requires("File[C:/temp/domain.py]")
                     .that_requires("File[C:/temp/common.py]")
      }


    end

  end

end
