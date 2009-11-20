module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      def log_info_with_railsalitics sql, name, time
        Railsalitics::Collector.report_sql sql, name, time
      end
      alias_method_chain :log_info, :railsalitics
    end
  end
end