#
# fmw_rcu_repository
#
# Copyright 2015 Oracle. All Rights Reserved
#
Puppet::Type.type(:fmw_rcu_repository).provide(:posix) do
  confine :kernel => ['Linux']
  defaultfor :kernel => ['Linux']

  def self.instances
    []
  end

  def install
    user                   = resource[:os_user]
    group                  = resource[:os_group]
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
    FileUtils.chown(user, group, tmp_file.path)

    components_string = ' -component ' + rcu_components.join(' -component ')

    command = "export JAVA_HOME=#{java_home_dir};#{oracle_home_dir}/bin/rcu -silent -createRepository -databaseType ORACLE -connectString #{db_connect_url} -dbUser #{db_connect_user} -dbRole SYSDBA  -schemaPrefix #{rcu_prefix} #{components_string} -f < #{tmp_file.path}"
    Puppet.debug "rcu command: #{command}"
    output = `su - #{user} -c '#{command}'`
    Puppet.info "rcu result: #{output}"
  end

  def drop
    user                   = resource[:os_user]
    group                  = resource[:os_group]
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
    FileUtils.chown(user, group, tmp_file.path)

    components_string = ' -component ' + rcu_components.join(' -component ')

    command = "export JAVA_HOME=#{java_home_dir};#{oracle_home_dir}/bin/rcu -silent -dropRepository -databaseType ORACLE -connectString #{db_connect_url} -dbUser #{db_connect_user} -dbRole SYSDBA  -schemaPrefix #{rcu_prefix} #{components_string} -f < #{tmp_file.path}"
    Puppet.debug "rcu command: #{command}"
    output = `su - #{user} -c '#{command}'`
    Puppet.info "rcu result: #{output}"
  end

  def status
    user                = resource[:os_user]
    version             = resource[:version]
    middleware_home_dir = resource[:middleware_home_dir]
    jdbc_connect_url    = resource[:jdbc_connect_url]
    db_connect_password = resource[:db_connect_password]
    rcu_prefix          = resource[:name]
    db_connect_user     = resource[:db_connect_user]
    tmp_dir             = resource[:tmp_dir]

    if version == '10.3.6'
      wlst_utility = "#{middleware_home_dir}/wlserver_10.3/common/bin/wlst.sh"
    else
      wlst_utility = "#{middleware_home_dir}/oracle_common/common/bin/wlst.sh"
    end

    command = "#{wlst_utility} #{tmp_dir}/checkrcu.py #{jdbc_connect_url} #{db_connect_password} #{rcu_prefix} #{db_connect_user}"
    Puppet.debug "rcu command: #{command}"
    output = `su - #{user} -c '#{command} 2>&1'`
    Puppet.info output
    output.each_line do |li|
      unless li.nil?
        Puppet.debug "line #{li}"
        if li.include? 'found'
          Puppet.debug 'rcu prefix found'
          return :present
        end
        fail('Cannot connect to the database') if li.include? 'IO Error'
      end
    end
    :absent
  end
end
