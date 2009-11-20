require 'monitor'
require 'digest/sha1' if not defined? Digest::SHA1

module Railsalitics
  # Collects data from hooks inside framework or 
  class Collector
    # Sets up Collector's backend
    @@requests = 0
    def self.setup
      @@buffer = []
      #@@buffer.extend(MonitorMixin)
      @@lock = Mutex.new
    end
    # Logs message into buffer
    def self.report msg
      @@lock.synchronize do
        @@buffer << {:date => Time.now, :request_id => Thread.current[:railsalitics_request_id]}.merge(msg)
      end
    end
    # Prepares passed log for upload to Railsalitics.COM
    def self.report_log log
      self.report({:type => 'log'}.merge(log))
    end
    # Prepares passed exception for upload to Railsalitics.COM
    def self.report_exception exception
      self.report({:type => 'exception', :class => exception.class.name, :message => exception.to_s, :backtrace => exception.backtrace})
    end
    # Prepares passed request information for upload to Railsalitics.COM
    def self.report_request controller, action_time, render_time
      @@requests += 1
      self.report({:type => 'request',
                   :request_controller => controller.controller_name,
                   :request_action => controller.action_name,
                   :request_params => controller.params,
                   :request_session => controller.session,
                   :request_method => controller.request.request_method,
                   :request_scheme => controller.request.protocol,
                   :request_hostname => controller.request.host,
                   :request_port => controller.request.port,
                   :request_uri => controller.request.request_uri,
                   :user_agent => controller.request.user_agent,
                   :action_time => action_time,
                   :render_time => render_time
      })
    end
    # Prepares passed exception for upload to Railsalitics.COM
    def self.report_request_time request_time
      self.report({:type => 'request_time', :request_time => request_time})
    end
    # Prepares passed information about sql query for upload to Railsalitics.COM
    def self.report_sql sql, name, time
      if sql == 'BEGIN'
        TransactionLog.start
      elsif sql == 'COMMIT'
        TransactionLog.clear
      else
        self.report({:type => 'sql', :sql => sql, :name => name, :time => time, :transaction_id => TransactionLog.get})
      end
    end
    def self.requests
      r, @@requests = @@requests, 0
      return r
    end
    # Read actual buffer content
    def self.extract
      buffer = []
      @@lock.synchronize do
        buffer, @@buffer = @@buffer, []
      end
      return buffer
    end
  end

  class TransactionLog
    @@data = {}
    def self.start
      @@data[Thread.current.object_id] = Time.now.to_i.to_s + rand(1000).to_s
    end
    def self.get
      @@data[Thread.current.object_id]
    end
    def self.clear
      @@data.delete(Thread.current.object_id)
    end
  end
end