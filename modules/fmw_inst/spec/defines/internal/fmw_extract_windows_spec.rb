require 'spec_helper'

describe 'fmw_inst::internal::fmw_extract_windows', :type => :define do

  describe "soa_suite 11g" do
    let(:params){{:source_file          => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                  :source_2_file        => 'C:/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                  :create_file_check    => 'C:/temp/soa_suite/Disk1',
                  :create_2_file_check  => 'C:/temp/soa_suite/Disk4',
                  :tmp_dir              => 'C:/temp',
                  :version              => '10.3.6',
                  :middleware_home_dir  => 'C:/oracle/middleware',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}

    it  {
         should contain_exec('extract soa_suite file 1').with(
            command: 'unzip -o C:/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip -d C:/temp/soa_suite',
            creates: 'C:/temp/soa_suite/Disk1',
            cwd:     'C:/temp',
            path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware\\wlserver_10.3\\server\\adr',
          )
        }
    it  {
         should contain_exec('extract soa_suite file 2').with(
            command: 'unzip -o C:/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip -d C:/temp/soa_suite',
            creates: 'C:/temp/soa_suite/Disk4',
            cwd:     'C:/temp',
            path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware\\wlserver_10.3\\server\\adr',
          ).that_requires('Exec[extract soa_suite file 1]')
        }

  end

  describe "soa_suite 12c" do
    let(:params){{:source_file          => 'C:/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
                  :create_file_check    => 'C:/temp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                  :tmp_dir              => 'C:/temp',
                  :version              => '12.1.3',
                  :middleware_home_dir  => 'C:/oracle/middleware',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}
    it  {
         should contain_exec('extract soa_suite file 1').with(
            command: 'unzip -o C:/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip -d C:/temp/soa_suite',
            creates: 'C:/temp/soa_suite/fmw_12.1.3.0.0_soa.jar',
            cwd:     'C:/temp',
            path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware\\oracle_common\\adr',
          )
        }

  end

end

