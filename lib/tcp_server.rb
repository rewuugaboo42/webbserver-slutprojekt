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
      request_string = read_request(session)

      request  = Request.build(request_string)

      if static_file?(request.path)
        response = get_static_file(request.path)
      else
        response = @app.call(request)
      end

      session.print response.to_s
      session.close
    end
  end

  private

  def read_request(session)
    data = ""

    while line = session.gets
      data += line
      break if line == "\r\n"
    end

    if data =~ /Content-Length: (\d+)/
      content_length = $1.to_i
      body = session.read(content_length)
      data += body if body
    end

    data
  end

  def static_file?(path)
    path.start_with?("/css", "/js", "/images")
  end

  def get_static_file(path)
    file_path = File.join("public", path)

    return Response.new(status: 404, body: "File not found") unless File.exist?(file_path)

    content_type = get_content_type(file_path)

    Response.new(
      status: 200,
      body: File.binread(file_path),
      headers: {
        "Content-Type" => content_type
      }
    )
  end

  def get_content_type(file_path)
    case File.extname(file_path)
    when ".css"  then "text/css"
    when ".js"   then "application/javascript"
    when ".png"  then "image/png"
    when ".jpg", ".jpeg" then "image/jpeg"
    when ".gif"  then "image/gif"
    when ".html" then "text/html"
    else "text/plain"
    end
  end
end