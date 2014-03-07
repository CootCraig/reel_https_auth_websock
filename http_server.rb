require 'log4r'
require 'reel'

require_relative './http_request_router'

module ReelHttpsAuthWebsock
  class HttpServer
    attr_reader :host
    attr_reader :port
    attr_reader :supervisor
    attr_reader :tls_certificate
    attr_reader :tls_key

    def initialize(ahost,aport,acertificate,akey)
      @logger = Log4r::Logger['base::HttpServer'] || Log4r::Logger['base']
      @host = ahost
      @port = aport
      @tls_certificate = acertificate
      @tls_key = akey
      @supervisor = nil
      start
    end

    private

    # @!visibility private
    def start
      options = { cert: @tls_certificate, key: @tls_key }
      @logger.info "Starting server on #{@host}:#{@port}"
      @supervisor = Reel::Server::HTTPS.supervise(@host, @port, options) do |connection|
        # For keep-alive support
        connection.each_request do |request|
          if request.websocket?
            @logger.debug "received a websocket request"
            begin
              Celluloid::Actor[:time_server].async.add_websocket(request.websocket)
            rescue => ex
              @logger.error "add_websocket #{ex.to_s}\n#{ex.backtrace}"
            end
          else
            HttpRequestRouter.instance.request_page(request)
          end
        end

        # Reel takes care of closing the connection for you
        # If you would like to hand the connection off to another thread or actor,
        # use, connection.detach and then manually call connection.close when done
      end
    end

  end
end

