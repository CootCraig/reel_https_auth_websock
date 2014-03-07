require 'pathname'
require 'haml'
require 'socket'

require_relative './version'

module ReelHttpsAuthWebsock
  class RequestHtml
    include Singleton
    def initialize
      @logger = Log4r::Logger['base::RequestHtml'] || Log4r::Logger['base']
      @public_folder_pathname = App.script_folder_pathname + 'public'
      @logger.info "public_folder_pathname #{@public_folder_pathname}"
    end
    def request_page(request)
      if request.path == '/'
        page = 'index.html'
      else
        page = request.path.sub(%r{^/},'')
      end
      page = page.sub(%r{html$},'haml')
      page_pathname = @public_folder_pathname + page
      page_full_path = page_pathname.to_s
      @logger.debug "render haml from #{page_full_path}"
      if File.exists?(page_full_path)
        begin
          page_engine = Haml::Engine.new(File.read(page_full_path))
          page_html = page_engine.render(Object.new,{:version => ReelHttpsAuthWebsock::VERSION, :hostname => Socket.gethostname})
          request.respond :ok, page_html
        rescue => ex
          @logger.error "request_page: #{ex.to_s}\n#{ex.backtrace}"
          request.respond :not_found, "Render error"
        end
      else
        request.respond :not_found, "Page not found."
      end
    end
  end
end
