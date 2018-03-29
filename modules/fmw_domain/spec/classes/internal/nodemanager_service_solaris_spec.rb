require 'spec_helper'

describe 'fmw_domain::internal::nodemanager_service_solaris', :type => :class do

  describe 'domain' do

    let :pre_condition do
       "
          include fmw_domain

       "
    end

    describe "service" do

      let(:facts) {{ operatingsystem:           'Solaris',
                     kernel:                    'SunOS',
                     osfamily:                  'Solaris',
                     operatingsystemmajrelease: '11',
                     architecture:              'i86pc' }}
      let(:params){{ :script_name          => 'nodemanager',
                     :nodemanager_bin_path => '/aaa/bbb',
                  }}

      it  { should contain_file('/etc/nodemanager').with(
                        ensure:             'present',
                        mode:               '0755',
                      )
      }

      it  { should contain_file('/var/tmp/nodemanager_smf_nodemanager.xml').with(
                        ensure:             'present',
                        mode:               '0755',
                      )
      }

      it  { should contain_exec('svvcfg nodemanager import').with(
            command:            'svccfg -v import /var/tmp/nodemanager_smf_nodemanager.xml',
            path:               '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin',
            unless:             "svccfg list | grep nodemanager"
           ).that_requires('File[/etc/nodemanager]').that_requires('File[/var/tmp/nodemanager_smf_nodemanager.xml]')
      }

      it  { should contain_service('nodemanager').with(
             ensure:             'running',
             enable:             true
           ).that_requires("Exec[svvcfg nodemanager import]")
      }
    end
  end
end
