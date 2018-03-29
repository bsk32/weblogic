#
# fmw_bsu_patch_linux
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_bsu_patch).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  def self.instances
    []
  end

  def install
    patch_id            = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]

    command = "C:\\Windows\\System32\\cmd.exe /c \"cd #{middleware_home_dir}\\utils\\bsu && #{middleware_home_dir}\\utils\\bsu\\bsu.cmd -install -patchlist=#{patch_id} -prod_dir=#{weblogic_home_dir} -verbose\""
    output = Puppet::Util::Execution.execute command, :failonfail => true
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
    patch_id            = resource[:name]
    middleware_home_dir = resource[:middleware_home_dir]
    weblogic_home_dir   = resource[:weblogic_home_dir]

    command = "C:\\Windows\\System32\\cmd.exe /c \"cd #{middleware_home_dir}\\utils\\bsu && #{middleware_home_dir}\\utils\\bsu\\bsu.cmd -view -status=applied -prod_dir=#{weblogic_home_dir} -verbose\""
    output = Puppet::Util::Execution.execute command, :failonfail => true

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
