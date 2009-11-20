require 'zlib' unless defined? Zlib
require 'net/http' unless defined? Net::HTTP
require 'cgi' unless defined? CGI

module Railsalitics
  #Upload data to Railsalitics.COM data
  class Uploader #< Thread
    # Uploads data to Railsalitics.COM
    def initialize buffer
      #super(b) do |buffer|
        begin
          # Clean data
          buffer.each do |item|
            if item[:type] == 'request'
              clean_request item
            end
            if item[:type] == 'sql'
              clean_sql item
            end
          end
          # Prepare(serialization, compression) data for upload
          upload_data = [Config.api_key, buffer].to_json
          compressor = Zlib::Deflate.new(Zlib::BEST_SPEED)
          upload_data = CGI::escape(compressor.deflate(upload_data, Zlib::FINISH))
          compressor.close
          # Prepare HTTP request
          req = Net::HTTP::Post.new("/collector/upload")
          req.content_length = upload_data.length
          req.content_type = 'application/x-gzip'
          req.body = upload_data
          # Upload data to Railsalitics.COM
          http = Net::HTTP.new(Config.host, Config.port)
          http.use_ssl = true if Config.ssl
          response = http.start { |h| h.request(req) }
        rescue Exception => e
          Logger.log :error, e.inspect
        end
      #end
    end
    # Cleans params and session according to configuration
    def clean_request item
      remove = Config.remove_fields
      scramble = Config.scramble_fields
      # Clean request params
      prms = {}
      item[:request_params].each do |n,v|
        (prms[n] = if scramble.include? n.to_s
          '***'
        else
          v
        end) unless remove.include? n.to_s
      end if item[:request_params]
      item[:request_params] = prms
      # Clean session
      ses = {}
      item[:request_session].each do |n,v|
        (ses[n] = if scramble.include? n.to_s
          '***'
        else
          v
        end) unless remove.include? n.to_s
      end if item[:request_session]
      item[:request_session] = ses
    end
    # Cleans SQL
    def clean_sql item
      item[:sql].gsub! /"([^"\\]*(\\.[^"\\]*)*)"/, '"***"'
      item[:sql].gsub! /'([^'\\]*(\\.[^'\\]*)*)'/, '\'***\''
    end
  end
end