require 'log4r'
require 'reel'
require 'socket'

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
          # Ordinarily we'd route the request here, e.g.
          # route request.url
          request.respond :ok, "hello, world! From #{Socket.gethostname}"
        end

        # Reel takes care of closing the connection for you
        # If you would like to hand the connection off to another thread or actor,
        # use, connection.detach and then manually call connection.close when done
      end
    end

  end
end

