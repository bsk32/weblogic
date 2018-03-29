require 'spec_helper'

describe 'fmw_inst::internal::fmw_install_linux', :type => :define do

  describe "soa_suite 11g" do
    let(:params){{:java_home_dir        => '/usr/java/jdk1.7.0_75',
                  :installer_file       => '/tmp/soa_suite/Disk1/runInstaller',
                  :rsp_file             => '/tmp/soa_fmw_11g.rsp',
                  :version              => '10.3.6',
                  :oracle_home_dir      => '/opt/oracle/middleware/Oracle_SOA1',
                  :orainst_dir          => '/etc',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it  {
         should contain_exec('Install soa_suite').with(
            command: '/tmp/soa_suite/Disk1/runInstaller -silent -response /tmp/soa_fmw_11g.rsp -waitforcompletion -ignoreSysPrereqs -invPtrLoc /etc/oraInst.loc -jreLoc /usr/java/jdk1.7.0_75 -Djava.io.tmpdir=/tmp',
            creates: '/opt/oracle/middleware/Oracle_SOA1',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          )
        }

  end

  describe "soa_suite 12c" do
    let(:params){{:java_home_dir        => '/usr/java/jdk1.7.0_75',
                  :installer_file       => '/tmp/soa_suite/fmw_12.1.3.0.0_soa.jar',
                  :rsp_file             => '/tmp/soa_fmw_12c.rsp',
                  :version              => '12.1.3',
                  :oracle_home_dir      => '/opt/oracle/middleware/soa/bin',
                  :orainst_dir          => '/etc',
                  :os_user              => 'oracle',
                  :os_group             => 'oinstall',
                  :tmp_dir              => '/tmp',
                }}
    let(:title) {'soa_suite'}
    let(:facts) {{ :kernel          => 'Linux',
                   :operatingsystem => 'CentOS',
                   :osfamily        => 'RedHat' }}
    it  {
         should contain_exec('Install soa_suite').with(
            command: '/usr/java/jdk1.7.0_75/bin/java -Xmx1024m -Djava.io.tmpdir=/tmp -jar /tmp/soa_suite/fmw_12.1.3.0.0_soa.jar -waitforcompletion -silent -responseFile /tmp/soa_fmw_12c.rsp -invPtrLoc /etc/oraInst.loc -jreLoc /usr/java/jdk1.7.0_75',
            creates: '/opt/oracle/middleware/soa/bin',
            user:    'oracle',
            group:   'oinstall',
            cwd:     '/tmp',
          )
        }
  end

end

