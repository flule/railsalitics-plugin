
ActionController::Base.logger = Logger.new(Railsalitics::Logger.new)
ActionController::Base.logger.progname = 'Rails::ActionController'
ActionController::Base.logger.formatter = Railsalitics::Formatter.new
ActionController::Base.logger.level = eval("Logger::#{Railsalitics::Config.log_level}")

ActiveRecord::Base.logger = Logger.new(Railsalitics::Logger.new)
ActiveRecord::Base.logger.progname = 'Rails::ActiveRecord'
ActiveRecord::Base.logger.formatter = Railsalitics::Formatter.new
ActiveRecord::Base.logger.level = eval("Logger::#{Railsalitics::Config.log_level}")

ActionMailer::Base.logger = Logger.new(Railsalitics::Logger.new)
ActionMailer::Base.logger.progname = 'Rails::ActionMailer'
ActionMailer::Base.logger.formatter = Railsalitics::Formatter.new
ActionMailer::Base.logger.level = eval("Logger::#{Railsalitics::Config.log_level}")

RAILS_DEFAULT_LOGGER = Logger.new(Railsalitics::Logger.new)
RAILS_DEFAULT_LOGGER.progname = 'Rails'
RAILS_DEFAULT_LOGGER.formatter = Railsalitics::Formatter.new
RAILS_DEFAULT_LOGGER.level = eval("Logger::#{Railsalitics::Config.log_level}")