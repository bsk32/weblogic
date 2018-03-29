# Puppet parser functions
module Puppet::Parser::Functions
  newfunction(:fmw_domain_replace_slash, :type => :rvalue) do |args|
    directory = args[0].strip
    directory.gsub('\\\\', '/').gsub('\\', '/')
  end
end