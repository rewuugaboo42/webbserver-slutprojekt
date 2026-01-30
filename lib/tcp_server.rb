require 'socket'
require_relative 'request'
require_relative 'get_request'
require_relative 'post_request'
require_relative 'router'
require_relative 'response'

class HTTPServer
  def initialize(port)
    @port = port
    @router = Router.new

    @router.get "/" do |request|
      "<h1>Root side not found!</h1>"
    end 

    @router.get "/hello" do |request|
      "<h1>Hello, World!</h1>"
      #erb(:"test/index")
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
        response = Response.new(status: 200, body: body)
      else
        response = Response.new(status: 404, body: "Not Found")
      end

      session.print response.to_s
      session.close
    end
  end
end

server = HTTPServer.new(4567)
server.start