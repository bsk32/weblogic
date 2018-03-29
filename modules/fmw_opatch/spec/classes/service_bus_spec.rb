require 'spec_helper'

describe 'fmw_opatch::service_bus', :type => :class do

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

          class { 'fmw_inst::service_bus':
            source_file   => '/software/ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
          }

          class { 'fmw_opatch':
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            version             => '10.3.6',
            middleware_home_dir => '/opt/oracle/middleware_1036',
          }


        "
    end

    describe "service_bus 11g" do
      let(:params){{:patch_id             => '20423630',
                    :source_file          => '/software/p20423630_111170_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_fmw_opatch__internal__fmw_extract('20423630').with(
                      source_file:         '/software/p20423630_111170_Generic.zip',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423630').with(
                      ensure:               'present',
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      oracle_home_dir:      '/opt/oracle/middleware_1036/Oracle_OSB1',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      tmp_dir:              '/tmp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract[20423630]')
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

          class { 'fmw_inst::service_bus':
            source_file   => 'C:/software/ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
          }

          class { 'fmw_opatch':
            java_home_dir       => 'C:/java/jdk1.7.0_75',
            version             => '10.3.6',
            middleware_home_dir => 'C:/oracle/middleware_1036'
          }

        "
    end


    describe "service_bus 11g windows" do
      let(:params){{:patch_id             => '20423630',
                    :source_file          => 'C:/software/p20423630_111170_Generic.zip',
                  }}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_fmw_opatch__internal__fmw_extract_windows('20423630').with(
                      source_file:         'C:/software/p20423630_111170_Generic.zip',
                      tmp_dir:             'C:/temp',
                    )
      }

      it  { should contain_fmw_opatch_patch('20423630').with(
                      ensure:               'present',
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      oracle_home_dir:      'C:/oracle/middleware_1036\\Oracle_OSB1',
                      tmp_dir:              'C:/temp',
                    ).that_requires('Fmw_opatch::Internal::Fmw_extract_windows[20423630]')
      }

    end

  end


end

