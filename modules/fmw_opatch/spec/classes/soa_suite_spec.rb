require 'spec_helper'

describe 'fmw_opatch::soa_suite', :type => :class do

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
            middleware_home_dir => '/opt/oracle/middleware_1036',
          }

          class { 'fmw_inst::soa_suite':
            source_file   => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
            source_2_file => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
          }

          class { 'fmw_opatch':
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            version             => '10.3.6',
            middleware_home_dir => '/opt/oracle/middleware_1036',
          }


        "
    end

    describe "soa_suite 11g" do
      let(:params){{:patch_id             => '20423535',
                    :source_file          => '/software/p20423535_111170_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_fmw_opatch__internal__fmw_extract('20423535').with(
                      source_file:         '/software/p20423535_111170_Generic.zip',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423535').with(
                      ensure:               'present',
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      oracle_home_dir:      '/opt/oracle/middleware_1036/Oracle_SOA1',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      tmp_dir:              '/tmp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract[20423535]')
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

          class { 'fmw_opatch':
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1213',
          }

        "
    end

    describe "soa_suite 12c" do
      let(:params){{:patch_id             => '20423408',
                    :source_file          => '/software/p20423408_121300_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_fmw_opatch__internal__fmw_extract('20423408').with(
                      source_file:         '/software/p20423408_121300_Generic.zip',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423408').with(
                      ensure:               'present',
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      oracle_home_dir:      '/opt/oracle/middleware_1213',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      tmp_dir:              '/tmp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract[20423408]')
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

          class { 'fmw_inst':
            version             => '10.3.6',
            middleware_home_dir => 'C:/oracle/middleware_1036'
          }

          class { 'fmw_inst::soa_suite':
            source_file   => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
            source_2_file => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
          }

          class { 'fmw_opatch':
            java_home_dir       => 'C:/java/jdk1.7.0_75',
            version             => '10.3.6',
            middleware_home_dir => 'C:/oracle/middleware_1036'
          }

        "
    end


    describe "soa_suite 11g windows" do
      let(:params){{:patch_id             => '20423535',
                    :source_file          => 'C:/software/p20423535_111170_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_fmw_opatch__internal__fmw_extract_windows('20423535').with(
                      source_file:         'C:/software/p20423535_111170_Generic.zip',
                      tmp_dir:             'C:/temp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423535').with(
                      ensure:               'present',
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      oracle_home_dir:      'C:/oracle/middleware_1036\\Oracle_SOA1',
                      tmp_dir:              'C:/temp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract_windows[20423535]')
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

          class { 'fmw_opatch':
            java_home_dir       => 'C:/java/jdk1.7.0_75',
            middleware_home_dir => 'C:/oracle/middleware_1213'
          }

        "
    end


    describe "soa_suite 12c windows" do
      let(:params){{:patch_id             => '20423408',
                    :source_file          => 'C:/software/p20423408_121300_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_fmw_opatch__internal__fmw_extract_windows('20423408').with(
                      source_file:         'C:/software/p20423408_121300_Generic.zip',
                      tmp_dir:             'C:/temp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423408').with(
                      ensure:               'present',
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      oracle_home_dir:      'C:/oracle/middleware_1213',
                      tmp_dir:              'C:/temp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract_windows[20423408]')
      }


    end

  end

end

