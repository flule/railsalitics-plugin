# Where to look for configuration.
config_file = "#{RAILS_ROOT}/config/railsalitics.yml"
# Where are plugin files located ?
path = File.expand_path(File.dirname(__FILE__))
# Load plugin
Dir["#{path}/lib/*.rb"].each do |file|
  require(file)
end
# If file does not exist, do not try to load it
if File.exists? config_file
  require 'yaml' unless defined? YAML
  RAILS_DEFAULT_LOGGER.info 'Railsalitics plugin found.'
  ::Railsalitics::Config.setup config_file
end

# Check whether plugin should be activated
if ::Railsalitics::Config.active
  ::RAILS_DEFAULT_LOGGER.info 'Railsalitics plugin active.'
  # Collect information from Rails
  ::Railsalitics::Collector.setup
  # Time based upload to Railsalitics.COM
  ::Railsalitics::Watcher.setup
  # Add hooks into the framework
  require "#{path}/hooks/action_controller/dispatcher"
  require "#{path}/hooks/action_controller/base"
  require "#{path}/hooks/active_record/base"
  #require "#{path}/hooks/logger/railsalitics_logger"
  #require "#{path}/hooks/logger/railsalitics_formatter"
  #require "#{path}/hooks/logger/logger"  
else
  RAILS_DEFAULT_LOGGER.info 'Railsalitics plugin disabled.'
end