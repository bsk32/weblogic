require 'spec_helper'

describe 'fmw_domain::internal::nodemanager_service_windows', :type => :class do

  describe '1036' do

    let :pre_condition do
       "
          class { 'fmw_domain':
            version                       => '10.3.6',
            java_home_dir                 => 'c:\\java\\jdk1.7.0_75',
            middleware_home_dir           => 'C:\\Oracle\\middleware_1036',
            weblogic_home_dir             => 'c:\\oracle\\middleware_1036\\wlserver_10.3',
            domains_dir                   => 'c:\\oracle\\middleware_1036\\user_projects\\domains',
            apps_dir                      => 'c:\\oracle\\middleware_1036\\user_projects\\applications',
            domain_name                   => 'base_xxx',
            weblogic_password             => 'Welcome01',
            adminserver_listen_address    => '1.1.1.1',
            nodemanager_listen_address    => '1.1.1.1',
          }

       "
    end

    describe "service" do

      let(:facts) {{ operatingsystem:           'windows',
                     kernel:                    'windows',
                     osfamily:                  'windows'}}
      let(:params){{ :bin_dir               => 'C:/aaa/bbb',
                  }}

      it  { should contain_fmw_domain_add_nodemanager("Add nodemanager for C:/aaa/bbb").with(
                        ensure:             'present',
                        bin_dir:             'C:/aaa/bbb',
                        version:             '10.3.6',
                        domain_name:         'base_xxx',
                        domain_dir:          "c:\\oracle\\middleware_1036\\user_projects\\domains/base_xxx",
                        middleware_home_dir: 'C:\\Oracle\\middleware_1036',
                        java_home_dir:       'c:\\java\\jdk1.7.0_75',
                      )
      }

      it  { should contain_fmw_domain_nodemanager_service('start nodemanager for C:/aaa/bbb').with(
                        ensure:              'running',
                        version:             '10.3.6',
                        domain_name:         'base_xxx',
                      ).that_requires("Fmw_domain_add_nodemanager[Add nodemanager for C:/aaa/bbb]")
      }
    end
  end
end
