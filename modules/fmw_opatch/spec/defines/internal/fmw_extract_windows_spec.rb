require 'spec_helper'

describe 'fmw_opatch::internal::fmw_extract_windows', :type => :define do

  describe "soa_suite 11g" do
    let(:params){{:source_file          => 'C:/software/p20423535_111170_Generic.zip',
                  :tmp_dir              => 'C:/temp',
                  :version              => '10.3.6',
                  :middleware_home_dir  => 'C:/oracle/middleware',
                }}
    let(:title) {'20423535'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}

    it  {
         should contain_exec('extract 20423535').with(
            command: 'unzip -o C:/software/p20423535_111170_Generic.zip -d C:/temp',
            creates: 'C:/temp/20423535',
            cwd:     'C:/temp',
            path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware\\wlserver_10.3\\server\\adr',
          )
        }

  end

  describe "soa_suite 12c" do
    let(:params){{:source_file          => 'C:/software/p20423408_121300_Generic.zip',
                  :tmp_dir              => 'C:/temp',
                  :version              => '12.1.3',
                  :middleware_home_dir  => 'C:/oracle/middleware',
                }}
    let(:title) {'20423408'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}
    it  {
         should contain_exec('extract 20423408').with(
            command: 'unzip -o C:/software/p20423408_121300_Generic.zip -d C:/temp',
            creates: 'C:/temp/20423408',
            cwd:     'C:/temp',
            path:    'C:\\Windows\\system32;C:\\Windows;C:/oracle/middleware\\oracle_common\\adr',
          )
        }

  end

end

