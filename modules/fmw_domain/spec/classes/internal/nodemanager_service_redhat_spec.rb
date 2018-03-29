require 'spec_helper'

describe 'fmw_domain::internal::nodemanager_service_redhat', :type => :class do

  describe 'domain' do

    let :pre_condition do
       "
          include fmw_domain

       "
    end

    describe "service" do

      let(:facts) {{ :kernel          => 'Linux',
                     :operatingsystem => 'CentOS',
                     :osfamily        => 'RedHat' }}
      let(:params){{ :script_name     => 'nodemanager'
                  }}

      it  { should contain_exec("chkconfig nodemanager").with(
            command:            'chkconfig --add nodemanager',
            unless:             "chkconfig | /bin/grep 'nodemanager'",
            path:               '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
           )
      }

      it  { should contain_service('nodemanager').with(
             ensure:             'running',
             enable:             true
           ).that_requires("Exec[chkconfig nodemanager]")
      }
    end
  end
end
