require 'spec_helper'

describe 'fmw_inst::internal::fmw_install_windows', :type => :define do

  describe "soa_suite 11g" do
    let(:params){{:java_home_dir        => 'C:/java/jdk1.7.0_75',
                  :installer_file       => 'C:/temp/soa_suite/Disk1/runInstaller',
                  :rsp_file             => 'C:/temp/soa_fmw_11g.rsp',
                  :version              => '10.3.6',
                  :oracle_home_dir      => 'C:/oracle/middleware/Oracle_SOA1',
                  :tmp_dir              => 'C:/temp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}
    it  {
         should contain_exec('Install soa_suite').with(
            command: "C:/temp/soa_suite/Disk1/runInstaller -silent -response C:/temp/soa_fmw_11g.rsp -waitforcompletion -ignoreSysPrereqs -jreLoc C:/java/jdk1.7.0_75 -Djava.io.tmpdir=C:/temp",
            creates: 'C:/oracle/middleware/Oracle_SOA1',
          )
        }

  end

  describe "soa_suite 12c" do
    let(:params){{:java_home_dir        => 'C:/java/jdk1.7.0_75',
                  :installer_file       => 'C/temp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                  :rsp_file             => 'C/temp/soa_fmw_12c.rsp',
                  :version              => '12.1.3',
                  :oracle_home_dir      => 'C:/oracle/middleware/soa/bin',
                  :tmp_dir              => 'C:/temp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'windows',
                   :operatingsystem => 'windows',
                   :osfamily        => 'windows' }}
    it  {
         should contain_exec('Install soa_suite').with(
            command: 'C:/java/jdk1.7.0_75/bin/java.exe -Xmx1024m -Djava.io.tmpdir=C:/temp -jar C/temp/soa_suite/fmw_12.1.3.0.0_soa.jar -waitforcompletion -silent -responseFile C/temp/soa_fmw_12c.rsp -jreLoc C:/java/jdk1.7.0_75',
            creates: 'C:/oracle/middleware/soa/bin',
          )
        }
  end

end

