#
# fmw_domain_nodemanager_service
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_domain_nodemanager_service).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  def self.instances
    []
  end

  def start
    service_name = retrieve_service_name
    output = `C:\\Windows\\System32\\cmd.exe /c "sc start "#{service_name}""`
    Puppet.info "#{service_name} startup output #{output}"
  end

  def status
    service_name = retrieve_service_name

    output = `C:\\Windows\\System32\\cmd.exe /c "sc query "#{service_name}""`
    Puppet.info "#{service_name} status output #{output}"

    output.each_line do |line|
      unless line.nil?
        if line.include? 'STOPPED'
          return :stopped
        end
        if line.include? 'RUNNING'
          return :running
        end
      end
    end
    :stopped
  end

  def retrieve_service_name
    version            = resource[:version]
    domain_name        = resource[:domain_name]

    last_char = 0
    first_char = 0
    service_name = nil

    if version == '10.3.6'
      service_check_name = 'Oracle WebLogic NodeManager'
    else
      service_check_name = "Oracle Weblogic #{domain_name} NodeManager"
    end

    output = `C:\\Windows\\System32\\cmd.exe /c "wmic service where "name like '#{service_check_name}%'" "`
    Puppet.debug "output #{output}"

    output.each_line do |line|
      unless line.nil?
        last_char  = line.index('CheckPoint') if line.include? 'CheckPoint'
        first_char = line.index('Caption') if line.include? 'Caption'
        if line.include? service_check_name
          service_name = line[first_char..(last_char - 1)].strip
          Puppet.debug("--- #{first_char} #{last_char} #{service_name}")
        end
      end
    end

    fail "nodemanager service not found" if service_name.nil?
    service_name
  end

end
