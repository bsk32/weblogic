#
# fmw_rcu_repository
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_rcu_repository).provide(:windows) do
  confine :kernel => :windows
  defaultfor :kernel => :windows

  def self.instances
    []
  end

  def install
    oracle_home_dir        = resource[:oracle_home_dir]
    rcu_prefix             = resource[:name]
    db_connect_user        = resource[:db_connect_user]
    db_connect_url         = resource[:db_connect_url]
    rcu_components         = resource[:rcu_components]
    db_connect_password    = resource[:db_connect_password]
    rcu_component_password = resource[:rcu_component_password]
    java_home_dir          = resource[:java_home_dir]

    script = 'rcu_input'
    content = "#{db_connect_password}\n"
    for i in 0..rcu_components.length
      content += "#{rcu_component_password}\n"
    end

    tmp_file = Tempfile.new([script, '.py'])
    tmp_file.write(content)
    tmp_file.close

    components_string = ' -component ' + rcu_components.join(' -component ')

    command = "set JAVA_HOME=#{java_home_dir} && #{oracle_home_dir}\\bin\\rcu.bat -silent -createRepository -databaseType ORACLE -connectString #{db_connect_url} -dbUser #{db_connect_user} -dbRole SYSDBA  -schemaPrefix #{rcu_prefix} #{components_string} -f < #{tmp_file.path}"
    Puppet.info "rcu command: #{command}"
    output = `C:\\Windows\\System32\\cmd.exe /c \"#{command}\"`
    Puppet.info "rcu result: #{output}"
  end

  def drop
    oracle_home_dir     = resource[:oracle_home_dir]
    rcu_prefix          = resource[:name]
    db_connect_user     = resource[:db_connect_user]
    db_connect_url      = resource[:db_connect_url]
    rcu_components      = resource[:rcu_components]
    db_connect_password    = resource[:db_connect_password]
    rcu_component_password = resource[:rcu_component_password]
    java_home_dir       = resource[:java_home_dir]

    script = 'rcu_input'
    content = "#{db_connect_password}\n"
    for i in 0..rcu_components.length
      content += "#{rcu_component_password}\n"
    end

    tmp_file = Tempfile.new([script, '.py'])
    tmp_file.write(content)
    tmp_file.close

    components_string = ' -component ' + rcu_components.join(' -component ')

    command = "set JAVA_HOME=#{java_home_dir} && #{oracle_home_dir}\\bin\\rcu.bat -silent -dropRepository -databaseType ORACLE -connectString #{db_connect_url} -dbUser #{db_connect_user} -dbRole SYSDBA  -schemaPrefix #{rcu_prefix} #{components_string} -f < #{tmp_file.path}"
    Puppet.debug "rcu command: #{command}"
    output = `C:\\Windows\\System32\\cmd.exe /c \"#{command}\"`
    Puppet.info "rcu result: #{output}"
  end

  def status
    version             = resource[:version]
    middleware_home_dir = resource[:middleware_home_dir]
    jdbc_connect_url    = resource[:jdbc_connect_url]
    db_connect_password = resource[:db_connect_password]
    rcu_prefix          = resource[:name]
    db_connect_user     = resource[:db_connect_user]
    tmp_dir             = resource[:tmp_dir]

    if version == '10.3.6'
      wlst_utility = "#{middleware_home_dir}\\wlserver_10.3\\common\\bin\\wlst.cmd"
    else
      wlst_utility = "#{middleware_home_dir}\\oracle_common\\common\\bin\\wlst.cmd"
    end

    command = "#{wlst_utility} #{tmp_dir}/checkrcu.py #{jdbc_connect_url} #{db_connect_password} #{rcu_prefix} #{db_connect_user}"
    Puppet.debug "rcu command: #{command}"
    output = `C:\\Windows\\System32\\cmd.exe /c \"#{command}\" 2>&1`
    Puppet.debug "#{output}"
    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? 'found'
          Puppet.info 'rcu prefix found'
          return :present
        end
        fail('Cannot connect to the database') if li.include? 'IO Error'
      end
    end
    :absent
  end
end
