v = Rails::VERSION

if(v::MAJOR >= 2 and v::MINOR >= 2)
  require "#{File.expand_path(File.dirname(__FILE__))}/starter.rb"
else
  RAILS_DEFAULT_LOG.error "Railsalitics.COM: Plugin is not supported with this version of RubyOnRails(#{v::STRING})."
end