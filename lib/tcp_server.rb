require 'socket'
require_relative 'application'
require_relative 'request'
require_relative 'get_request'
require_relative 'post_request'
require_relative 'response'

class HTTPServer
  def initialize(port, app)
    @port = port
    @app  = app
  end

  def start
    server = TCPServer.new(@port)
    puts "Listening on #{@port}"

    while session = server.accept
      data = ''
      while line = session.gets and line !~ /^\s*$/
        data += line
      end

      request  = Request.build(data)
      response = @app.call(request)
      if response == nil
        if File.exist?('./public/#{request.resource}')
          #las in filen... generera response

      session.print response.to_s
      session.close
    end
  end
end