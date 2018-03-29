require 'spec_helper'

describe 'fmw_bsu::internal::bsu', :type => :class do

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
      it  { should contain_file('/opt/oracle/middleware_1036/utils/bsu/cache_dir').with(
                      ensure: 'directory',
                    )
      }
      it  { should contain_exec('extract YUIS').with(
                      command: 'unzip -o /software/p20181997_1036_Generic.zip -d /opt/oracle/middleware_1036/utils/bsu/cache_dir',
                      creates: '/opt/oracle/middleware_1036/utils/bsu/cache_dir/YUIS.jar',
                    ).that_requires('File[/opt/oracle/middleware_1036/utils/bsu/cache_dir]')
      }
      it  { should contain_fmw_bsu_patch('YUIS').with(
                      ensure: 'present',
                      middleware_home_dir: '/opt/oracle/middleware_1036',
                      weblogic_home_dir:   '/opt/oracle/middleware_1036/wlserver_10.3',
                    ).that_requires('Exec[extract YUIS]')
      }

    end

    describe 'With attributes 12.1.1, on CentOS platform' do
      let(:facts) {{ operatingsystem:           'CentOS',
                     kernel:                    'Linux',
                     osfamily:                  'RedHat',
                     operatingsystemmajrelease: '6' }}
      let(:params){{
                    version:             '12.1.1',
                    middleware_home_dir: '/opt/oracle/middleware_1211',
                    patch_id:            'YUIS',
                    source_file:         '/software/p20181997_1036_Generic.zip',
                  }}
      it  { should contain_file('/opt/oracle/middleware_1211/utils/bsu/cache_dir').with(
                      ensure: 'directory',
                    )
      }
      it  { should contain_exec('extract YUIS').with(
                      command: 'unzip -o /software/p20181997_1036_Generic.zip -d /opt/oracle/middleware_1211/utils/bsu/cache_dir',
                      creates: '/opt/oracle/middleware_1211/utils/bsu/cache_dir/YUIS.jar',
                    ).that_requires('File[/opt/oracle/middleware_1211/utils/bsu/cache_dir]')
      }
      it  { should contain_fmw_bsu_patch('YUIS').with(
                      ensure: 'present',
                      middleware_home_dir: '/opt/oracle/middleware_1211',
                      weblogic_home_dir:   '/opt/oracle/middleware_1211/wlserver_12.1',
                    ).that_requires('Exec[extract YUIS]')
      }

    end

end
