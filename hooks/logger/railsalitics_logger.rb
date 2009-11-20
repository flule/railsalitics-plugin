module Railsalitics
  class Logger
    def initialize
    end

    def write msg
      Railsalitics::Collector.report_log msg
    end

    def close
    end
  end
end