module Railsalitics
  # Contains configuration of Railsalitics.COM plugin
  class Config
    # Load configuration
    def self.setup config_file
      @@defaults = { :host => 'railsalitics.com',
                     :port => 80,
                     :ssl => false,
                     :uri => '/collector/upload',
                     :api_key => '',
                     :remove_fields => [ 'session_id', '_csrf_token'],
                     :scramble_fields => [],
                     :log_level => 'INFO',
                     :active => false,
                     :interval => 60
      }
      begin
        @@config = YAML.load_file config_file
      rescue
        @@config = {}
        Logger.log :error, 'Railsalitics failed to load configuration.'
      end
    end
    # Generic method for getting information
    def self.get name
        @@config[name.to_s] || @@defaults[name.to_s]
    end
    # Host where to upload data
    def self.host
      self.get :host
    end
    # Port of the host
    def self.port
      self.get :port
    end
    # Use SSL ?
    def self.ssl
      self.get :ssl
    end
    # Key of the application
    def self.api_key
      self.get :api_key
    end
    # Fields to be removed from params and session
    def self.remove_fields
      self.get :remove_fields
    end
    def self.scramble_fields
      self.get :scramble_fields
    end
    # From what level to log messages
    def self.log_level
      self.get :log_level
    end
    # Is plugin active ?
    def self.active
      self.get :active
    end
    def self.interval
      self.get :interval
    end
  end
end