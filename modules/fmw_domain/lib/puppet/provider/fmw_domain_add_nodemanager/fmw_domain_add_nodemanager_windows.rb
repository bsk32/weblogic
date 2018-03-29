#
# fmw_domain_add_nodemanager
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_domain_add_nodemanager).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  def self.instances
    []
  end

  def install
    version             = resource[:version]
    bin_dir             = resource[:bin_dir]
    middleware_home_dir = resource[:middleware_home_dir]
    domain_dir          = resource[:domain_dir]
    java_home_dir       = resource[:java_home_dir]

    if version == '10.3.6'
      environment = { 'CLASSPATH' => "#{middleware_home_dir}\\wlserver_10.3\\server\\lib\\weblogic.jar",
                      'JAVA_HOME' => java_home_dir }
    else
      environment = { 'JAVA_OPTIONS' => "-Dohs.product.home=#{middleware_home_dir} -Dweblogic.RootDirectory=#{domain_dir}",
                      'JAVA_HOME'    => java_home_dir,
                      'MW_HOME'      => middleware_home_dir }
    end
    command = "C:\\Windows\\System32\\cmd.exe /c \"cd #{bin_dir} && installNodeMgrSvc.cmd\""
    output = Puppet::Util::Execution.execute command, :failonfail => true, :custom_environment => environment

    Puppet.info "fmw_domain_add_nodemanager done #{output}"
  end

  def status
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
          return :present
        end
      end
    end
    :absent
  end

end
