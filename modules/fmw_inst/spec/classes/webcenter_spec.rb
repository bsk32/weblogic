require 'spec_helper'

describe 'fmw_inst::webcenter', :type => :class do

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

    describe "webcenter 11g" do
      let(:params){{:install_type         => 'Typical',
                    :source_file          => '/software/fmw_wc_generic_11.1.1.9.0_disk1_1of2.zip',
                    :source_2_file        => '/software/fmw_wc_generic_11.1.1.9.0_disk1_2of2.zip',
                  }}
      let(:title) {'webcenter'}
      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}

      it  { should contain_file('/tmp/webcenter_fmw_11g.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\nSPECIFY_DOWNLOAD_LOCATION=false\nSKIP_SOFTWARE_UPDATES=true\nSOFTWARE_UPDATES_DOWNLOAD_LOCATION=\nORACLE_HOME=/opt/oracle/middleware_1036/Oracle_WC1\nMIDDLEWARE_HOME=/opt/oracle/middleware_1036\nAPPSERVER_TYPE=WLS\n\nAPPSERVER_LOCATION=/opt/oracle/middleware_1036\n\n\n[SYSTEM]\n[APPLICATIONS]\n[RELATIONSHIPS]\n",
                      mode:               '0755',
                      owner:              'oracle',
                      group:              'oinstall',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract('webcenter').with(
                      source_file:         '/software/fmw_wc_generic_11.1.1.9.0_disk1_1of2.zip',
                      source_2_file:       '/software/fmw_wc_generic_11.1.1.9.0_disk1_2of2.zip',
                      create_file_check:   '/tmp/webcenter/Disk1',
                      create_2_file_check: '/tmp/webcenter/Disk4',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_install_linux('webcenter').with(
                      java_home_dir:        '/usr/java/jdk1.7.0_75',
                      installer_file:       '/tmp/webcenter/Disk1/runInstaller',
                      rsp_file:             '/tmp/webcenter_fmw_11g.rsp',
                      version:              '10.3.6',
                      oracle_home_dir:      '/opt/oracle/middleware_1036/Oracle_WC1',
                      orainst_dir:          '/etc',
                      os_user:              'oracle',
                      os_group:             'oinstall',
                      tmp_dir:              '/tmp',
                    ).that_requires('File[/tmp/webcenter_fmw_11g.rsp]')
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


    describe "webcenter 11g windows" do
      let(:params){{:install_type         => 'Typical',
                    :source_file          => 'C:/software/fmw_wc_generic_11.1.1.9.0_disk1_1of2.zip',
                    :source_2_file        => 'C:/software/fmw_wc_generic_11.1.1.9.0_disk1_2of2.zip',
                  }}
      let(:title) {'webcenter'}
      let(:facts) {{ :kernel          => 'windows',
                     :operatingsystem => 'windows',
                     :osfamily        => 'windows' }}

      it  { should contain_file('C:/temp/webcenter_fmw_11g.rsp').with(
                      ensure:             'present',
                      # content:            "[ENGINE]\nResponse File Version=1.0.0.0.0\n[GENERIC]\nSPECIFY_DOWNLOAD_LOCATION=false\nSKIP_SOFTWARE_UPDATES=true\nSOFTWARE_UPDATES_DOWNLOAD_LOCATION=\nORACLE_HOME=C:/oracle/middleware_1036/Oracle_WC1\nMIDDLEWARE_HOME=C:/oracle/middleware_1036\nAPPSERVER_TYPE=WLS\n\nAPPSERVER_LOCATION=C:/oracle/middleware_1036\n\n\n[SYSTEM]\n[APPLICATIONS]\n[RELATIONSHIPS]\n",
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_extract_windows('webcenter').with(
                      version:             '10.3.6',
                      middleware_home_dir: 'C:/oracle/middleware_1036',
                      source_file:         'C:/software/fmw_wc_generic_11.1.1.9.0_disk1_1of2.zip',
                      source_2_file:       'C:/software/fmw_wc_generic_11.1.1.9.0_disk1_2of2.zip',
                      create_file_check:   'C:/temp/webcenter/Disk1',
                      create_2_file_check: 'C:/temp/webcenter/Disk4',
                      tmp_dir:             'C:/temp',
                    )
      }

      it  { should contain_fmw_inst__internal__fmw_install_windows('webcenter').with(
                      java_home_dir:        'C:/java/jdk1.7.0_75',
                      installer_file:       'C:/temp/webcenter/Disk1/setup.exe',
                      rsp_file:             'C:/temp/webcenter_fmw_11g.rsp',
                      version:              '10.3.6',
                      oracle_home_dir:      'C:/oracle/middleware_1036/Oracle_WC1',
                      tmp_dir:              'C:/temp',
                    ).that_requires('File[C:/temp/webcenter_fmw_11g.rsp]')
      }


    end

  end

end

