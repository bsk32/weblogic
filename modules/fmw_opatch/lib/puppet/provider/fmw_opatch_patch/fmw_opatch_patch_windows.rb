#
# fmw_opatch_patch
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_opatch_patch).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  def self.instances
    []
  end

  def install
    patch_id               = resource[:name]
    oracle_home_dir        = resource[:oracle_home_dir]
    oracle_common_home_dir = resource[:oracle_common_home_dir]
    java_home_dir          = resource[:java_home_dir]
    tmp_dir                = resource[:tmp_dir]

    command = "C:\\Windows\\System32\\cmd.exe /c \"#{oracle_common_home_dir}\\OPatch\\opatch.bat apply -silent -jre #{java_home_dir}\\jre -oh #{oracle_home_dir} #{tmp_dir}/#{patch_id}\""
    output = Puppet::Util::Execution.execute command, :failonfail => true

    Puppet.info "opatch result: #{output}"

    # Check for 'Result: Success' else raise

    result = false
    output.each_line do |li|
      unless li.nil?
        if li.include? 'OPatch completed' or li.include? 'OPatch succeeded'
          result = true
        end
      end
    end
    fail(output) if result == false
    Puppet.info 'opatch done'
  end

  def status
    patch_id               = resource[:name]
    oracle_home_dir        = resource[:oracle_home_dir]
    oracle_common_home_dir = resource[:oracle_common_home_dir]

    command = "C:\\Windows\\System32\\cmd.exe /c \"#{oracle_common_home_dir}\\OPatch\\opatch.bat lsinventory -patch_id -oh #{oracle_home_dir}\""
    output = Puppet::Util::Execution.execute command, :failonfail => true

    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        opatch = li[5, li.index(':') - 5].strip + ';' if li['Patch'] && li[': applied on']
        unless opatch.nil?
          if opatch.include? patch_id
            Puppet.debug 'found patch'
            return :present
          end
        end
      end
    end
    :absent
  end
end
