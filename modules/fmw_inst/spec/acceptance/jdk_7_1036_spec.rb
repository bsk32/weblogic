require 'spec_helper_acceptance'

describe 'jdk_7_1036' do

  if os[:platform]  =~ /windows/

  else
    # Serverspec examples can be found at
    # http://serverspec.org/resource_types.html
    it 'Should apply the manifest without error' do
      pp = <<-EOS
        node default {

          include fmw_jdk::rng_service

          $java_home_dir       = '/usr/java/jdk1.7.0_79'
          $version             = '10.3.6'
          $middleware_home_dir = '/opt/oracle/middleware_1036'

          Class['fmw_wls::setup'] ->
            Class['fmw_wls::install']

          class { 'fmw_jdk::install':
            java_home_dir => $java_home_dir,
            source_file   => '/software/jdk-7u79-linux-x64.tar.gz',
          }

          # # can be removed when all the default are used.
          # class { 'fmw_wls':
          #   version             => $version,
          #   middleware_home_dir => $middleware_home_dir,
          #   os_user_uid         => '600',
          # }

          # include fmw_wls::setup

          # # this requires fmw_jdk::install
          # class { 'fmw_wls::install':
          #   java_home_dir => $java_home_dir,
          #   source_file   => '/software/wls1036_generic.jar',
          # }

          # # this requires fmw_wls::install
          # class { 'fmw_bsu::weblogic':
          #   version             => $version,
          #   middleware_home_dir => $middleware_home_dir,
          #   patch_id            => 'YUIS',
          #   source_file         => '/software/p20181997_1036_Generic.zip',
          # }

          # # can be removed when all the default are used.
          # class { 'fmw_inst':
          #   version             => $version,
          #   java_home_dir       => $java_home_dir,
          #   middleware_home_dir => $middleware_home_dir,
          # }

          # $files = ['/tmp/webcenter','/tmp/soa_suite','/tmp/service_bus']

          # file{$files:
          #   ensure  => absent,
          #   recurse => true,
          #   purge   => true,
          #   force   => true,
          # }

          # Class['fmw_bsu::weblogic'] ->
          #   File[$files] ->
          #     Class['fmw_inst::webcenter'] ->
          #       Class['fmw_inst::soa_suite'] ->
          #         Class['fmw_inst::service_bus']

          # # this requires fmw_wls::install
          # class { 'fmw_inst::webcenter':
          #   source_file   => '/software/ofm_wc_generic_11.1.1.9.0_disk1_1of2.zip',
          #   source_2_file => '/software/ofm_wc_generic_11.1.1.9.0_disk1_2of2.zip',
          # }

          # # this requires fmw_wls::install
          # class { 'fmw_inst::soa_suite':
          #   source_file   => '/software/ofm_soa_generic_11.1.1.7.0_disk1_1of2.zip',
          #   source_2_file => '/software/ofm_soa_generic_11.1.1.7.0_disk1_2of2.zip',
          # }

          # class { 'fmw_inst::service_bus':
          #   source_file   => '/software/ofm_osb_generic_11.1.1.7.0_disk1_1of1.zip',
          # }

        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      apply_manifest(pp, :catch_failures => true, :acceptable_exit_codes => [0, 2])
      # expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      shell('sleep 15')
    end

    describe file('/usr/java/jdk1.7.0_79') do
      it { should be_directory }
      it { should be_owned_by 'root' }
    end

    describe file('/usr/java/jdk1.7.0_79/bin/java') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_executable }
    end

    describe file('/usr/bin/java') do
      it { should be_symlink }
      it { should be_linked_to '/etc/alternatives/java' }
    end

    # describe group('oinstall') do
    #   it { should exist }
    # end

    # describe user('oracle') do
    #   it { should belong_to_group 'oinstall' }
    #   it { should have_home_directory '/home/oracle' }
    #   it { should have_login_shell '/bin/bash' }
    # end

    # describe file('/etc/oraInst.loc') do
    #   it { should be_file }
    #   it { should be_owned_by 'root' }
    #   it { should be_readable.by('others') }
    #   it { should contain 'inventory_loc=/home/oracle/oraInventory' }
    #   it { should contain 'inst_group=oinstall' }
    # end

    # describe file('/tmp/wls_11g.rsp') do
    #   it { should be_file }
    #   it { should contain '<data-value name="BEAHOME" value="/opt/oracle/middleware_1036" />' }
    # end

    # describe file('/home/oracle/oraInventory') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

    # describe file('/opt/oracle/middleware_1036') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

    # describe file('/opt/oracle/middleware_1036/wlserver_10.3/common/bin/wlst.sh') do
    #   it { should be_file }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    #   it { should be_executable }
    # end

    # describe file('/opt/oracle/middleware_1036/Oracle_OSB1') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

    # describe file('/opt/oracle/middleware_1036/Oracle_SOA1') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

    # describe file('/opt/oracle/middleware_1036/Oracle_WC1') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

    # describe file('/opt/oracle/middleware_1036/oracle_common') do
    #   it { should be_directory }
    #   it { should be_owned_by 'oracle' }
    #   it { should be_grouped_into 'oinstall' }
    # end

  end
end
