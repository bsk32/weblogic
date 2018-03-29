require 'spec_helper'

describe 'fmw_opatch::internal::fmw_extract', :type => :define do

  describe "patch soa_suite 12c" do
    let(:params){{:source_file          => '/software/p20423408_121300_Generic.zip',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'20423408'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}

    it { should contain_package('unzip').with_ensure('present') }
    it  {
         should contain_exec('extract 20423408').with(
            command: 'unzip -o /software/p20423408_121300_Generic.zip -d /tmp',
            creates: '/tmp/20423408',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          ).that_requires('Package[unzip]')
        }
  end

  describe "patch soa_suite 11g" do
    let(:params){{:source_file          => '/software/p20423535_111170_Generic.zip',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'20423535'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it { should contain_package('unzip').with_ensure('present') }
    it  {
         should contain_exec('extract 20423535').with(
            command: 'unzip -o /software/p20423535_111170_Generic.zip -d /tmp',
            creates: '/tmp/20423535',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          ).that_requires('Package[unzip]')
        }

  end

end

