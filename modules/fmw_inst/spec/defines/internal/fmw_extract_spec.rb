require 'spec_helper'

describe 'fmw_inst::internal::fmw_extract', :type => :define do

  describe "soa_suite 11g" do
    let(:params){{:source_file          => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
                  :source_2_file        => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
                  :create_file_check    => '/tmp/soa_suite/Disk1',
                  :create_2_file_check  => '/tmp/soa_suite/Disk4',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}

    it { should contain_package('unzip').with_ensure('present') }
    it  {
         should contain_exec('extract soa_suite file 1').with(
            command: 'unzip -o /software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip -d /tmp/soa_suite',
            creates: '/tmp/soa_suite/Disk1',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          ).that_requires('Package[unzip]')
        }
    it  {
         should contain_exec('extract soa_suite file 2').with(
            command: 'unzip -o /software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip -d /tmp/soa_suite',
            creates: '/tmp/soa_suite/Disk4',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          ).that_requires('Exec[extract soa_suite file 1]')
        }

  end

  describe "soa_suite 12c" do
    let(:params){{:source_file          => '/software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip',
                  :create_file_check    => '/tmp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it { should contain_package('unzip').with_ensure('present') }
    it  {
         should contain_exec('extract soa_suite file 1').with(
            command: 'unzip -o /software/fmw_12.1.3.0.0_soa_Disk1_1of1.zip -d /tmp/soa_suite',
            creates: '/tmp/soa_suite/fmw_12.1.3.0.0_soa.jar',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          ).that_requires('Package[unzip]')
        }

  end

end

