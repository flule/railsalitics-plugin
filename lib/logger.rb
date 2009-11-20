module Railsalitics
  # Logger used for logging Railsalitics.COM special information 
  class Logger
    @@logger = ::Logger.new "#{RAILS_ROOT}/log/railsalitics.log", 'monthly'
    def self.log severity, msg
      if @@logger.respond_to? severity
        @@logger.send severity, msg
      else
        @@logger.info "Severity #{severity} not found. Message was '#{msg}'."
      end
    end
  end
end