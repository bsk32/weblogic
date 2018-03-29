require 'spec_helper'

describe 'fmw_domain::internal::nodemanager_service_redhat_7', :type => :class do


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

      it  { should contain_file('/lib/systemd/system/nodemanager.service').with(
                        ensure:             'present',
                        mode:               '0755',
                        owner:              'oracle',
                        group:              'oinstall',
                      )
      }

      it  { should contain_exec("systemctl-daemon-reload-nodemanager").with(
            command:            '/bin/systemctl --system daemon-reload',
            path:               '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
            refreshonly:        true
           ).that_subscribes_to('File[/lib/systemd/system/nodemanager.service]').that_notifies('Service[nodemanager.service]')
      }

      it  { should contain_exec('systemctl-enable-nodemanager').with(
            command:            '/bin/systemctl enable nodemanager.service',
            path:               '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
            refreshonly:        true,
            unless:             "/bin/systemctl list-units --type service --all | /bin/grep 'nodemanager.service'"
           ).that_subscribes_to('Exec[systemctl-daemon-reload-nodemanager]').that_notifies('Service[nodemanager.service]')
      }

      it  { should contain_service('nodemanager.service').with(
             ensure:             'running',
             enable:             true
             ).that_requires("Exec[systemctl-daemon-reload-nodemanager]").that_requires("Exec[systemctl-enable-nodemanager]")
      }
    end
  end
end
