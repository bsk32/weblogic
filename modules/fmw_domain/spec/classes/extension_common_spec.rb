require 'spec_helper'

describe 'fmw_domain::extension_jrf', :type => :class do

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

          class { 'fmw_inst':
            version             => '10.3.6',
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1036'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
            source_2_file => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
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

      it  { should contain_file('/tmp/jrf.py').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/opt/oracle/middleware/user_projects/applications').with(
                      ensure:             'directory',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST add jrf').with(
                      ensure:              'present',
                      extension_check:     'em.ear',
                      os_user:             'oracle',
                      script_file:         '/tmp/jrf.py',
                      middleware_home_dir: '/opt/oracle/middleware',
                      weblogic_home_dir:   '/opt/oracle/middleware/wlserver_10.3',
                      java_home_dir:       '/usr/java/jdk1.7.0_75',
                      tmp_dir:             '/tmp',
                      domain_dir:          '/opt/oracle/middleware/user_projects/domains/base_xxx',
                    ).that_requires("File[/opt/oracle/middleware/user_projects/applications]")
                     .that_requires("File[/tmp/jrf.py]")
      }

    end

  end

  describe 'unix cluster 1036' do

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

          class { 'fmw_inst':
            version             => '10.3.6',
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1036'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
            source_2_file => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
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
            soa_suite_cluster             => 'soa_cluster',
          }

          include fmw_domain::domain
       "
    end

    describe "wls 11g" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/jrf.py').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/opt/oracle/middleware/user_projects/applications').with(
                      ensure:             'directory',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST add jrf').with(
                      ensure:             'present',
                      extension_check:    'em.ear',
                      os_user:            'oracle',
                      script_file:         '/tmp/jrf.py',
                      middleware_home_dir: '/opt/oracle/middleware',
                      weblogic_home_dir:   '/opt/oracle/middleware/wlserver_10.3',
                      java_home_dir:       '/usr/java/jdk1.7.0_75',
                      tmp_dir:             '/tmp',
                      domain_dir:          '/opt/oracle/middleware/user_projects/domains/base_xxx',
                    ).that_requires("File[/opt/oracle/middleware/user_projects/applications]")
                     .that_requires("File[/tmp/jrf.py]")
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

          class { 'fmw_inst':
            version             => '12.1.3',
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip'
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

      it  { should contain_file('/tmp/jrf.py').with(
                      ensure:             'present',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_file('/opt/oracle/middleware_1213/user_projects/applications').with(
                      ensure:             'directory',
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST add jrf').with(
                      ensure:             'present',
                      extension_check:    'em.ear',
                      os_user:            'oracle',
                      script_file:         '/tmp/jrf.py',
                      middleware_home_dir: '/opt/oracle/middleware_1213',
                      weblogic_home_dir:   '/opt/oracle/middleware_1213/wlserver',
                      java_home_dir:       '/usr/java/jdk1.7.0_75',
                      tmp_dir:             '/tmp',
                      domain_dir:          '/opt/oracle/middleware_1213/user_projects/domains/base_xxx',
                    ).that_requires("File[/opt/oracle/middleware_1213/user_projects/applications]")
                     .that_requires("File[/tmp/jrf.py]")
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

          class { 'fmw_inst':
            version             => '10.3.6',
            java_home_dir       => 'c:\\java\\jdk1.7.0_75',
            middleware_home_dir => 'C:\\Oracle\\middleware_1036',
          }

          class { 'fmw_inst::soa_suite':
            source_file   => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
            source_2_file => 'c:\\software\\ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
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

      it  { should contain_file('C:/temp/jrf.py').with(
                      ensure:             'present',
                    )
      }

      it  { should contain_file('C:\\Oracle\\middleware_1036\\user_projects\\applications').with(
                      ensure:             'directory',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST add jrf').with(
                      ensure:             'present',
                      extension_check:    'em.ear',
                      script_file:         'C:/temp/jrf.py',
                      middleware_home_dir: 'C:\\Oracle\\middleware_1036',
                      weblogic_home_dir:   'C:\\Oracle\\middleware_1036\\wlserver_10.3',
                      java_home_dir:       'c:\\java\\jdk1.7.0_75',
                      tmp_dir:             'C:/temp',
                      domain_dir:          'C:/Oracle/middleware_1036/user_projects/domains/base_xxx',
                    ).that_requires("File[C:\\Oracle\\middleware_1036\\user_projects\\applications]")
                     .that_requires("File[C:/temp/jrf.py]")
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

          class { 'fmw_inst':
            version             => '12.1.3',
            java_home_dir       => 'c:\\java\\jdk1.7.0_75',
            middleware_home_dir => 'C:\\Oracle\\middleware_1213'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => 'c:\\software\\fmw_12.1.3.0.0_soa_Disk1_1of1.zip'
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


      it  { should contain_file('C:/temp/jrf.py').with(
                      ensure:             'present',
                    )
      }

      it  { should contain_file('C:\\Oracle\\middleware_1213\\user_projects\\applications').with(
                      ensure:             'directory',
                    )
      }

      it  { should contain_fmw_domain_wlst('WLST add jrf').with(
                      ensure:             'present',
                      extension_check:    'em.ear',
                      script_file:         'C:/temp/jrf.py',
                      middleware_home_dir: 'C:\\Oracle\\middleware_1213',
                      weblogic_home_dir:   'C:\\Oracle\\middleware_1213\\wlserver',
                      java_home_dir:       'c:\\java\\jdk1.7.0_75',
                      tmp_dir:             'C:/temp',
                      domain_dir:          'C:/Oracle/middleware_1213/user_projects/domains/base_xxx',
                    ).that_requires("File[C:\\Oracle\\middleware_1213\\user_projects\\applications]")
                     .that_requires("File[C:/temp/jrf.py]")
      }

    end

  end



end
