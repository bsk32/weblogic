require 'spec_helper'

describe 'fmw_bsu::weblogic', :type => :class do

  describe 'unix' do 
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
        "
    end

    describe 'When all attributes are default, on an unspecified platform' do

      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
      end
    end

    describe 'With attributes, on an unspecified platform' do
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: '/opt/oracle/middleware_1036',
                    patch_id:            'YUIS',
                    source_file:         '/software/p20181997_1036_Generic.zip',
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /Not supported Operation System, please use it on windows, linux or solaris host/)
      end
    end

    describe 'With default attributes, wrong version, on CentOS platform'  do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    middleware_home_dir: '/opt/oracle/middleware_1036',
                    patch_id:            'YUIS',
                    source_file:         '/software/p20181997_1036_Generic.zip',
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /Not supported WebLogic version, please use it on WebLogic 10.3.6 or 12.1.1/)
      end
    end

    describe 'With default attributes missing patchid, on CentOS platform'  do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: '/opt/oracle/middleware_1036',
                    source_file:         '/software/p20181997_1036_Generic.zip',
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /patch_id parameter cannot be empty/)
      end
    end

    describe 'With default attributes missing source file, on CentOS platform'  do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: '/opt/oracle/middleware_1036',
                    patch_id:            'YUIS',
                  }}
      it do
        expect { should contain_package('xxx')
               }.to raise_error(Puppet::Error, /source_file parameter cannot be empty/)
      end
    end


    describe 'With attributes 10.3.6, on CentOS platform' do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: '/opt/oracle/middleware_1036',
                    patch_id:            'YUIS',
                    source_file:         '/software/p20181997_1036_Generic.zip',
                  }}
      it  { should contain_class('fmw_bsu::internal::bsu').with(
                      version:             '10.3.6',
                      middleware_home_dir: '/opt/oracle/middleware_1036',
                      patch_id:            'YUIS',
                      source_file:         '/software/p20181997_1036_Generic.zip',
                      os_user:             'oracle',
                      os_group:            'oinstall',
                      tmp_dir:             '/tmp',
                    )
      }
    end

  end


  describe 'windows' do 
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


    describe 'With attributes 10.3.6, on CentOS platform' do
      let(:facts) {{ operatingsystem:           'windows',
                     kernel:                    'windows',
                     osfamily:                  'windows'}}
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: 'C:/oracle/middleware_1036',
                    patch_id:            'YUIS',
                    source_file:         'C:/software/p20181997_1036_Generic.zip',
                  }}
      it  { should contain_class('fmw_bsu::internal::bsu_windows').with(
                      version:             '10.3.6',
                      middleware_home_dir: 'C:/oracle/middleware_1036',
                      patch_id:            'YUIS',
                      source_file:         'C:/software/p20181997_1036_Generic.zip',
                    )
      }
    end
  end

end
