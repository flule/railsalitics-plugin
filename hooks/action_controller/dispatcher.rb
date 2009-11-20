require 'digest/sha1' if not defined? Digest::SHA1

module ActionController
  class Dispatcher
    def call_with_railsalitics env
      # Add request_id globally for request
      id = Railsalitics::Config.api_key + Time.now.to_i.to_s + Railsalitics::SecureRandom.hex(20)
      Thread.current[:railsalitics_request_id] = Digest::SHA1.hexdigest(id.to_s)
      # Start measuring of whole response
      request_start = Time.now
      # Call the framework
      response = call_without_railsalitics env
      # Time spent for the whole request
      Railsalitics::Collector.report_request_time((Time.now - request_start) * 1000)
      # Return response to user
      return response
    end
    alias_method_chain :call, :railsalitics
  end
end