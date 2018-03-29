require 'spec_helper'

describe 'fmw_bsu::internal::bsu_windows', :type => :class do

    describe 'With attributes 10.3.6, on Windows platform' do
      let(:facts) {{ operatingsystem:           'windows',
                     kernel:                    'windows',
                     osfamily:                  'windows'}}
      let(:params){{
                    version:             '10.3.6',
                    middleware_home_dir: 'C:/oracle/middleware_1036',
                    patch_id:            'YUIS',
                    source_file:         'C:/software/p20181997_1036_Generic.zip',
                  }}
      it  { should contain_file('C:/oracle/middleware_1036\\utils\\bsu\\cache_dir').with(
                      ensure: 'directory',
                    )
      }
      it  { should contain_exec('extract YUIS').with(
                      command: 'unzip -o C:/software/p20181997_1036_Generic.zip -d C:/oracle/middleware_1036/utils/bsu/cache_dir',
                      path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware_1036\\wlserver_10.3\\server\\adr',
                      creates: 'C:/oracle/middleware_1036/utils/bsu/cache_dir/YUIS.jar',
                    ).that_requires('File[C:/oracle/middleware_1036\\utils\\bsu\\cache_dir]')
      }
      it  { should contain_fmw_bsu_patch('YUIS').with(
                      ensure: 'present',
                      middleware_home_dir: 'C:/oracle/middleware_1036',
                      weblogic_home_dir:   'C:/oracle/middleware_1036\\wlserver_10.3',
                    ).that_requires('Exec[extract YUIS]')
      }

    end

    describe 'With attributes 12.1.1, on Windows platform' do
      let(:facts) {{ operatingsystem:           'windows',
                     kernel:                    'windows',
                     osfamily:                  'windows'}}
      let(:params){{
                    version:             '12.1.1',
                    middleware_home_dir: 'C:/oracle/middleware_1211',
                    patch_id:            'YUIS',
                    source_file:         'C:/software/p20181997_1036_Generic.zip',
                  }}
      it  { should contain_file('C:/oracle/middleware_1211\\utils\\bsu\\cache_dir').with(
                      ensure: 'directory',
                    )
      }
      it  { should contain_exec('extract YUIS').with(
                      command: 'unzip -o C:/software/p20181997_1036_Generic.zip -d C:/oracle/middleware_1211/utils/bsu/cache_dir',
                      path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware_1211\\wlserver_12.1\\server\\adr',
                      creates: 'C:/oracle/middleware_1211/utils/bsu/cache_dir/YUIS.jar',
                    ).that_requires('File[C:/oracle/middleware_1211\\utils\\bsu\\cache_dir]')
      }
      it  { should contain_fmw_bsu_patch('YUIS').with(
                      ensure: 'present',
                      middleware_home_dir: 'C:/oracle/middleware_1211',
                      weblogic_home_dir:   'C:/oracle/middleware_1211\\wlserver_12.1',
                    ).that_requires('Exec[extract YUIS]')
      }

    end

end
