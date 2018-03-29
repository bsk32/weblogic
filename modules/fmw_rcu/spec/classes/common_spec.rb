require 'spec_helper'

describe 'fmw_rcu::common', :type => :class do

  describe 'unix 1036' do 
    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
          }

          class { 'fmw_wls':
            version             => '10.3.6',
            middleware_home_dir => '/opt/oracle/middleware_1036',
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/wls1036_generic.jar',
          }
        "
    end

    describe "common 11g" do
      let(:params){{:version                => '10.3.6',
                    :java_home_dir          => '/usr/java/jdk1.7.0_75',
                    :middleware_home_dir    => '/opt/oracle/middleware_1036',
                    :source_file            => '/software/p20423535_111170_Generic.zip',
                    :rcu_prefix             => 'DEV2',
                    :jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
                    :db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
                    :db_connect_password    => 'Welcome01',
                    :rcu_component_password => 'Welcome02',
                  }}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  {
           should contain_fmw_rcu__internal__rcu_extract('common').with(
              source_file: '/software/p20423535_111170_Generic.zip',
              creates_dir: '/tmp/rcu/rcuHome',
              os_user:     'oracle',
              os_group:    'oinstall',
              tmp_dir:     '/tmp',
            ).that_comes_before('Fmw_rcu_repository[DEV2]')
          }

      it  {
           should contain_file('/tmp/checkrcu.py').with(
              ensure:  'present',
              source:  'puppet:///modules/fmw_rcu/checkrcu.py',
              owner:   'oracle',
              group:   'oinstall',
              mode:    '0775',
            )
          }

      it  {
           should contain_fmw_rcu_repository('DEV2').with(
              ensure:              'present',
              os_user:             'oracle',
              oracle_home_dir:     '/tmp/rcu/rcuHome',
              middleware_home_dir: '/opt/oracle/middleware_1036',
              java_home_dir:       '/usr/java/jdk1.7.0_75',
              tmp_dir:             '/tmp',
              version:             '10.3.6',
              jdbc_connect_url:    'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
              db_connect_url:      '10.10.10.15:1521:soarepos.example.com',
              db_connect_user:     'sys',
              db_connect_password: 'Welcome01',
              rcu_components:       ["ORASDPM", "MDS", "OPSS"],
            )
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
            middleware_home_dir => '/opt/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => '/usr/java/jdk1.7.0_75',
            source_file   => '/software/fmw_12.1.3.0.0_infrastructure.jar',
          }

          class { 'fmw_inst':
            middleware_home_dir => '/opt/oracle/middleware_1213',
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/p20423408_121300_Generic.zip',
          }

        "
    end

    describe "common 12c" do
      let(:params){{:version                => '12.1.3',
                    :java_home_dir          => '/usr/java/jdk1.7.0_75',
                    :middleware_home_dir    => '/opt/oracle/middleware_1213',
                    :oracle_home_dir        => '/opt/oracle/middleware_1213/oracle_common',
                    :rcu_prefix             => 'DEV2',
                    :jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
                    :db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
                    :db_connect_password    => 'Welcome01',
                    :rcu_component_password => 'Welcome02',
                  }}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}
      it  {
           should contain_file('/tmp/checkrcu.py').with(
              ensure:  'present',
              source:  'puppet:///modules/fmw_rcu/checkrcu.py',
              owner:   'oracle',
              group:   'oinstall',
              mode:    '0775',
            )
          }

      it  {
           should contain_fmw_rcu_repository('DEV2').with(
              ensure:              'present',
              os_user:             'oracle',
              oracle_home_dir:     '/tmp/rcu/rcuHome',
              middleware_home_dir: '/opt/oracle/middleware_1213',
              oracle_home_dir:     '/opt/oracle/middleware_1213/oracle_common',
              java_home_dir:       '/usr/java/jdk1.7.0_75',
              tmp_dir:             '/tmp',
              version:             '12.1.3',
              jdbc_connect_url:    'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
              db_connect_url:      '10.10.10.15:1521:soarepos.example.com',
              db_connect_user:     'sys',
              db_connect_password: 'Welcome01',
              rcu_components:      ["MDS", "IAU", "IAU_APPEND", "IAU_VIEWER", "OPSS", "WLS", "UCSUMS"],
            ).that_requires('File[/tmp/checkrcu.py]')
          }
    end

  end


  describe 'windows 1036' do 
    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => 'C:/java/jdk1.7.0_75',
            source_file   => 'C:/software/jdk-7u75-linux-x64.exe',
          }

          class { 'fmw_wls':
            version             => '10.3.6',
            middleware_home_dir => 'C:/oracle/middleware_1036'
          }

          class { 'fmw_wls::install':
            java_home_dir => 'C:/java/jdk1.7.0_75',
            source_file   => 'C:/software/wls1036_generic.jar',
          }

        "
    end

    describe "common 11g windows" do
      let(:params){{:version                => '10.3.6',
                    :java_home_dir          => 'C:/java/jdk1.7.0_75',
                    :middleware_home_dir    => 'C:/oracle/middleware_1036',
                    :source_file            => 'C:/software/p20423535_111170_Generic.zip',
                    :rcu_prefix             => 'DEV2',
                    :jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
                    :db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
                    :db_connect_password    => 'Welcome01',
                    :rcu_component_password => 'Welcome02',
                  }}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}
      it  {
           should contain_fmw_rcu__internal__rcu_extract_windows('common').with(
              version:             '10.3.6',
              middleware_home_dir: 'C:/oracle/middleware_1036',
              source_file:         'C:/software/p20423535_111170_Generic.zip',
              creates_dir:         'C:/temp\\rcu\\rcuHome',
              tmp_dir:             'C:/temp',
            ).that_comes_before('Fmw_rcu_repository[DEV2]')
          }
      it  {
           should contain_file('C:/temp/checkrcu.py').with(
              ensure:  'present',
              source:  'puppet:///modules/fmw_rcu/checkrcu.py',
            )
          }


      it  {
           should contain_fmw_rcu_repository('DEV2').with(
              ensure:              'present',
              oracle_home_dir:     'C:/temp\rcu\rcuHome',
              middleware_home_dir: 'C:/oracle/middleware_1036',
              java_home_dir:       'C:/java/jdk1.7.0_75',
              tmp_dir:             'C:/temp',
              version:             '10.3.6',
              jdbc_connect_url:    'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
              db_connect_url:      '10.10.10.15:1521:soarepos.example.com',
              db_connect_user:     'sys',
              db_connect_password: 'Welcome01',
              rcu_components:      ["ORASDPM", "MDS", "OPSS"],
            ).that_requires('File[C:/temp/checkrcu.py]')
          }
    end

  end

  describe 'windows 1213' do 
    let :pre_condition do
       "  class { 'fmw_jdk::install':
            java_home_dir => 'C:/java/jdk1.7.0_75',
            source_file   => 'C:/software/jdk-7u75-linux-x64.exe',
          }

          class { 'fmw_wls':
            version             => '12.1.3',
            middleware_home_dir => 'C:/oracle/middleware_1213'
          }

          class { 'fmw_wls::install':
            java_home_dir => 'C:/java/jdk1.7.0_75',
            source_file   => 'C:/software/fmw_12.1.3.0.0_infrastructure.jar',
          }

          class { 'fmw_inst':
            version             => '12.1.3',
            middleware_home_dir => 'C:/oracle/middleware_1213'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/p20423408_121300_Generic.zip',
          }

        "
    end


    describe "common 12c windows" do
      let(:params){{:version                => '12.1.3',
                    :java_home_dir          => 'C:/java/jdk1.7.0_75',
                    :middleware_home_dir    => 'C:/oracle/middleware_1213',
                    :oracle_home_dir        => 'C:/oracle/middleware_1213/oracle_common',
                    :rcu_prefix             => 'DEV2',
                    :jdbc_connect_url       => 'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
                    :db_connect_url         => '10.10.10.15:1521:soarepos.example.com',
                    :db_connect_password    => 'Welcome01',
                    :rcu_component_password => 'Welcome02',
                  }}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}
      it  {
           should contain_file('C:/temp/checkrcu.py').with(
              ensure:  'present',
              source:  'puppet:///modules/fmw_rcu/checkrcu.py',
            )
          }

      it  {
           should contain_fmw_rcu_repository('DEV2').with(
              ensure:              'present',
              oracle_home_dir:     'C:/oracle/middleware_1213/oracle_common',
              middleware_home_dir: 'C:/oracle/middleware_1213',
              java_home_dir:       'C:/java/jdk1.7.0_75',
              tmp_dir:             'C:/temp',
              version:             '12.1.3',
              jdbc_connect_url:    'jdbc:oracle:thin:@10.10.10.15:1521/soarepos.example.com',
              db_connect_url:      '10.10.10.15:1521:soarepos.example.com',
              db_connect_user:     'sys',
              db_connect_password: 'Welcome01',
              rcu_components:      ["MDS", "IAU", "IAU_APPEND", "IAU_VIEWER", "OPSS", "WLS", "UCSUMS"],
            ).that_requires('File[C:/temp/checkrcu.py]')
          }
    end

  end

end

