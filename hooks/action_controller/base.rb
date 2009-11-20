module ActionController
  class Base

    def perform_action_with_railsalitics(*args, &block)
      before = Time.now
      puts .inspect
      response = perform_action_without_railsalitics *args, &block
      Railsalitics::Collector.report_request self, (Time.now - before) * 1000, @railsalitics_render_time
      return response
    end

    def render_with_railsalitics(*args, &block)
      before = Time.now
      out = render_without_railsalitics(*args, &block)
      @railsalitics_render_time = (Time.now - before) * 1000
      return out
    end

    def rescue_action_with_railsalitics exception
      Railsalitics::Collector.report_exception(exception) unless ( respond_to?(:handler_for_rescue) and handler_for_rescue(exception) )
      rescue_action_without_railsalitics exception
    end

    alias_method_chain :rescue_action, :railsalitics
    alias_method_chain :perform_action, :railsalitics
    alias_method_chain :render, :railsalitics

  end
end