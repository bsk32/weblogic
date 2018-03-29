require 'spec_helper'

describe 'fmw_domain::internal::nodemanager_service_debian', :type => :class do

  describe "service" do

    let(:facts) {{ :kernel          => 'Linux',
                   :osfamily        => 'Debian' }}
    let(:params){{ :script_name     => 'nodemanager'
                }}

    it  { should contain_exec("update-rc.d nodemanager").with(
          command:            'update-rc.d nodemanager defaults',
          unless:             "ls /etc/rc3.d/*nodemanager | /bin/grep 'nodemanager'",
          path:               '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin'
         )
    }

    it  { should contain_service('nodemanager').with(
           ensure:             'running',
           enable:             true
         ).that_requires("Exec[update-rc.d nodemanager]")
    }

  end

end
