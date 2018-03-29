require 'spec_helper'

describe 'fmw_inst::mft', :type => :class do

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
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1213',
          }

        "
    end

    describe "mft 12c" do
      let(:params){{:source_file          => '/software/fmw_12.1.3.0.0_mft_Disk1_1of1.zip',
                    }}
      let(:title) {'mft'}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/mft_fmw_12c.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\n#DO NOT CHANGE THIS.\nResponse File Version=1.0.0.0.0\n\n[GENERIC]\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=/opt/oracle/middleware_1213\n\n#Set this variable value to the Installation Type selected. e.g. SOA Suite, BPM.\nINSTALL_TYPE=Typical\n",
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract('mft').with(
                      source_file:         '/software/fmw_12.1.3.0.0_mft_Disk1_1of1.zip',
                      create_file_check:   '/tmp/mft/fmw_12.1.3.0.0_mft.jar',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_linux[mft]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_linux('mft').with(
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      installer_file:       '/tmp/mft/fmw_12.1.3.0.0_mft.jar',
                      rsp_file:             '/tmp/mft_fmw_12c.rsp',
                      version:              '12.1.3',
                      oracle_home_dir:      '/opt/oracle/middleware_1213/mft/bin',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      os_group:             'oinstall',
                      tmp_dir:              '/tmp',
                    ).that_requires('File[/tmp/mft_fmw_12c.rsp]')
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
            java_home_dir       => 'C:/java/jdk1.7.0_75',
            middleware_home_dir => 'C:/oracle/middleware_1213'
          }

        "
    end


    describe "mft 12c windows" do
      let(:params){{:source_file          => 'C:/software/fmw_12.1.3.0.0_mft_Disk1_1of1.zip'
                  }}
      let(:title) {'mft'}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_file('C:/temp/mft_fmw_12c.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\n#DO NOT CHANGE THIS.\nResponse File Version=1.0.0.0.0\n\n[GENERIC]\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=C:/oracle/middleware_1213\n\n#Set this variable value to the Installation Type selected. e.g. SOA Suite, BPM.\nINSTALL_TYPE=Typical\n",
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract_windows('mft').with(
                      version:             '12.1.3',
                      middleware_home_dir: 'C:/oracle/middleware_1213',
                      source_file:         'C:/software/fmw_12.1.3.0.0_mft_Disk1_1of1.zip',
                      create_file_check:   'C:/temp/mft/fmw_12.1.3.0.0_mft.jar',
                      tmp_dir:             'C:/temp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_windows[mft]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_windows('mft').with(
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      installer_file:       'C:/temp/mft/fmw_12.1.3.0.0_mft.jar',
                      rsp_file:             'C:/temp/mft_fmw_12c.rsp',
                      version:              '12.1.3',
                      oracle_home_dir:      'C:/oracle/middleware_1213/mft/bin',
                      tmp_dir:              'C:/temp',
                    ).that_requires('File[C:/temp/mft_fmw_12c.rsp]')
      }


    end

  end

end

