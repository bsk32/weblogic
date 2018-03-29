require 'spec_helper'

describe 'fmw_inst::soa_suite', :type => :class do

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
            middleware_home_dir => '/opt/oracle/middleware_1036',
          }

        "
    end

    describe "soa_suite 11g" do
      let(:params){{:install_type         => 'SOA Suite',
                    :source_file          => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                    :source_2_file        => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                  }}
      let(:title) {'soa_suite'}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/soa_fmw_11g.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\nSPECIFY_DOWNLOAD_LOCATION=false\nSKIP_SOFTWARE_UPDATES=true\nSOFTWARE_UPDATES_DOWNLOAD_LOCATION=\nORACLE_HOME=/opt/oracle/middleware_1036/Oracle_SOA1\nMIDDLEWARE_HOME=/opt/oracle/middleware_1036\nAPPSERVER_TYPE=WLS\n\nAPPSERVER_LOCATION=/opt/oracle/middleware_1036\n\n\n[SYSTEM]\n[APPLICATIONS]\n[RELATIONSHIPS]\n",
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract('soa_suite').with(
                      source_file:         '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                      source_2_file:       '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                      create_file_check:   '/tmp/soa_suite/Disk1',
                      create_2_file_check: '/tmp/soa_suite/Disk4',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_linux[soa_suite]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_linux('soa_suite').with(
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      installer_file:       '/tmp/soa_suite/Disk1/runInstaller',
                      rsp_file:             '/tmp/soa_fmw_11g.rsp',
                      version:              '10.3.6',
                      oracle_home_dir:      '/opt/oracle/middleware_1036/Oracle_SOA1',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      os_group:             'oinstall',
                      tmp_dir:              '/tmp',
                    ).that_requires('File[/tmp/soa_fmw_11g.rsp]')
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
            java_home_dir       => '/usr/java/jdk1.7.0_75',
            middleware_home_dir => '/opt/oracle/middleware_1213',
          }

        "
    end

    describe "soa_suite 12c" do
      let(:params){{:install_type         => 'SOA Suite',
                    :source_file          => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
                    }}
      let(:title) {'soa_suite'}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/soa_fmw_12c.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\n#DO NOT CHANGE THIS.\nResponse File Version=1.0.0.0.0\n\n[GENERIC]\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=/opt/oracle/middleware_1213\n\n#Set this variable value to the Installation Type selected. e.g. SOA Suite, BPM.\nINSTALL_TYPE=SOA Suite\n",
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract('soa_suite').with(
                      source_file:         '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
                      create_file_check:   '/tmp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_linux[soa_suite]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_linux('soa_suite').with(
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      installer_file:       '/tmp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                      rsp_file:             '/tmp/soa_fmw_12c.rsp',
                      version:              '12.1.3',
                      oracle_home_dir:      '/opt/oracle/middleware_1213/soa/bin',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      os_group:             'oinstall',
                      tmp_dir:              '/tmp',
                    ).that_requires('File[/tmp/soa_fmw_12c.rsp]')
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
            java_home_dir       => 'C:/java/jdk1.7.0_75',
            middleware_home_dir => 'C:/oracle/middleware_1036'
          }

        "
    end


    describe "soa_suite 11g windows" do
      let(:params){{:install_type         => 'SOA Suite',
                    :source_file          => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                    :source_2_file        => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                  }}
      let(:title) {'soa_suite'}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_file('C:/temp/soa_fmw_11g.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\nSPECIFY_DOWNLOAD_LOCATION=false\nSKIP_SOFTWARE_UPDATES=true\nSOFTWARE_UPDATES_DOWNLOAD_LOCATION=\nORACLE_HOME=C:/oracle/middleware_1036/Oracle_SOA1\nMIDDLEWARE_HOME=C:/oracle/middleware_1036\nAPPSERVER_TYPE=WLS\n\nAPPSERVER_LOCATION=C:/oracle/middleware_1036\n\n\n[SYSTEM]\n[APPLICATIONS]\n[RELATIONSHIPS]\n",
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract_windows('soa_suite').with(
                      version:             '10.3.6',
                      middleware_home_dir: 'C:/oracle/middleware_1036',
                      source_file:         'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                      source_2_file:       'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                      create_file_check:   'C:/temp/soa_suite/Disk1',
                      create_2_file_check: 'C:/temp/soa_suite/Disk4',
                      tmp_dir:             'C:/temp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_windows[soa_suite]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_windows('soa_suite').with(
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      installer_file:       'C:/temp/soa_suite/Disk1/setup.exe',
                      rsp_file:             'C:/temp/soa_fmw_11g.rsp',
                      version:              '10.3.6',
                      oracle_home_dir:      'C:/oracle/middleware_1036/Oracle_SOA1',
                      tmp_dir:              'C:/temp',
                    ).that_requires('File[C:/temp/soa_fmw_11g.rsp]')
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


    describe "soa_suite 12c windows" do
      let(:params){{:install_type         => 'SOA Suite',
                    :source_file          => 'C:/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip'
                  }}
      let(:title) {'soa_suite'}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_file('C:/temp/soa_fmw_12c.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\n#DO NOT CHANGE THIS.\nResponse File Version=1.0.0.0.0\n\n[GENERIC]\n#The oracle home location. This can be an existing Oracle Home or a new Oracle Home\nORACLE_HOME=C:/oracle/middleware_1213\n\n#Set this variable value to the Installation Type selected. e.g. SOA Suite, BPM.\nINSTALL_TYPE=SOA Suite\n",
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract_windows('soa_suite').with(
                      version:             '12.1.3',
                      middleware_home_dir: 'C:/oracle/middleware_1213',
                      source_file:         'C:/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
                      create_file_check:   'C:/temp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                      tmp_dir:             'C:/temp',
                    ).that_comes_before('Fmw_inst::Internal::Fmw_install_windows[soa_suite]')
      }

      it  { should contain_fmw_inst__internal__fmw_install_windows('soa_suite').with(
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      installer_file:       'C:/temp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                      rsp_file:             'C:/temp/soa_fmw_12c.rsp',
                      version:              '12.1.3',
                      oracle_home_dir:      'C:/oracle/middleware_1213/soa/bin',
                      tmp_dir:              'C:/temp',
                    ).that_requires('File[C:/temp/soa_fmw_12c.rsp]')
      }


    end

  end

end

