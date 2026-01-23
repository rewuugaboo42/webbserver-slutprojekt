require 'socket'
require_relative 'request'
require_relative 'get_request'
require_relative 'post_request'
require_relative 'router'

class HTTPServer
  def initialize(port)
    @port = port
    @router = Router.new

    @router.get "/" do |request|
      "<h1>Root side not found!</h1>"
    end 

    @router.get "/hello" do |request|
      "<h1>Hello, World!</h1>"
    end
  end

  def start
    server = TCPServer.new(@port)
    puts "Listening on #{@port}"

    while session = server.accept
      data = ''
      while line = session.gets and line !~ /^\s*$/
        data += line
      end

      request = Request.build(data)
      route = @router.match(request)

      if route
        body = route[:block].call(request.resource)
        status = "HTTP/1.1 200 OK"
      else
        body = "Not Found"
        status = "HTTP/1.1 404 NOT FOUND"
      end

      session.print "#{status}\r\n"
      session.print "Content-Type: text/html\r\n"
      session.print "\r\n"
      session.print body
      session.close
    end
  end
end

server = HTTPServer.new(4567)
server.start