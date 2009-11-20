module Railsalitics
  # Runs in background, gets data, if data there is data to be uploaded, uploads it
  class Watcher < Thread
    # Upload periodicali data to server
    @@watcher = nil
    def self.watcher
      @@watcher
    end
    def self.watcher= watcher
      @@watcher = watcher
    end
    # Setup new watcher
    def self.setup
      Watcher.watcher = Watcher.new
      if defined?(PhusionPassenger)
        if $0 =~ /ApplicationSpawner/
          Watcher.watcher.exit
          Watcher.watcher = nil
        end
        PhusionPassenger.on_event(:starting_worker_process) do |forked|
          if Watcher.watcher and Watcher.watcher.respond_to?(:exit)
            Watcher.watcher.exit
          end
          Watcher.watcher = Watcher.new
#          if forked
#          else
#          end
        end
        PhusionPassenger.on_event(:stopping_worker_process) do
          Watcher.watcher.extract
        end
      end
    end
    def extract
      buffer = Collector.extract
      Logger.log :info, "Uploading #{buffer.length} ( #{Collector.requests} requests )"
      if buffer.length > 0
        Uploader.new(buffer)
      end
    end
    def initialize
      super do
        loop do
          begin
            sleep Config.interval
            extract
          rescue Exception => e
            Logger.log :error, e.inspect
          end
        end
      end
    end
  end
end