#
# fmw_bsu_patch_linux
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_bsu_patch).provide(:posix) do
  confine :kernel => ['Linux', 'SunOS']
  defaultfor :kernel => ['Linux', 'SunOS']

  def self.instances
    []
  end

  def install
    user                = resource[:os_user]
    patch_id            = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]

    command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh -install -patchlist=' + patch_id + ' -prod_dir=' + weblogic_home_dir + ' -verbose'
    output = `su - #{user} -c 'export USER="#{user}";export LOGNAME="#{user}";#{command}'`
    Puppet.info "bsu_patch result: #{output}"

    # Check for 'Result: Success' else raise

    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? 'Result: Success'
          result = true
        end
      end
    end
    fail(output) if result == false
    Puppet.info 'bsu_patch done'
  end

  def status
    user                = resource[:os_user]
    patch_id            = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]

    command = 'cd ' + middleware_home_dir + '/utils/bsu;' + middleware_home_dir + '/utils/bsu/bsu.sh -view -status=applied -prod_dir=' + weblogic_home_dir + ' -verbose'
    output = `su - #{user} -c '#{command}'`

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? patch_id
          Puppet.debug 'found patch'
          return :present
        end
      end
    end
    :absent
  end
end
