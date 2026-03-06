require 'socket'
require_relative 'application'
require_relative 'request'
require_relative 'get_request'
require_relative 'post_request'
require_relative 'response'

# HTTPServer class responsible for running the web server.
# It listens on a specified port, accepts incoming TCP connections,
# parses HTTP requests, and returns responses from the application.
class HTTPServer
  # Initializes a new HTTPServer.
  #
  # @param port [Integer] the port number the server will listen on.
  # @param app [Application] the application instance that will handle requests.
  def initialize(port, app)
    @port = port
    @app  = app
  end

  # Starts the HTTP server and begins listening for incoming connections.
  #
  # For each accepted client session, the server reads the request,
  # processes it through the application, and sends back a response.
  #
  # @return [void]
  def start
    server = TCPServer.new(@port)
    puts "Listening on #{@port}"

    while session = server.accept
      handle_session(session)
    end
  end

  private

  # Reads the HTTP request from the client session.
  #
  # It reads headers line-by-line until a blank line is reached.
  # If a `Content-Length` header exists, the corresponding body
  # content is also read.
  #
  # @param session [TCPSocket] the client session socket.
  # @return [String] the complete raw HTTP request string.
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

  # Handles a single client session.
  #
  # The request is parsed into a Request object, routed through the
  # application, and the resulting response is written back to the client.
  #
  # @param session [TCPSocket] the client session socket.
  # @return [void]
  def handle_session(session)
    request_string = read_request(session)

    request = Request.build(request_string)

    response =
      if static_file?(request.path)
        get_static_file(request.path)
      else
        @app.call(request)
      end

    session.print response.to_s
    session.close
  end

  # Determines whether the requested path refers to a static file.
  #
  # Static files are expected to be located in folders such as
  # `/css`, `/js`, or `/images`.
  #
  # @param path [String] the requested path.
  # @return [Boolean] true if the path refers to a static asset.
  def static_file?(path)
    path.start_with?("/css", "/js", "/images")
  end

  # Retrieves a static file from the public directory and
  # returns it as an HTTP response.
  #
  # @param path [String] the requested file path.
  # @return [Response] the HTTP response containing the file contents
  #   or a 404 response if the file does not exist.
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

  # Determines the appropriate HTTP Content-Type header
  # based on the file extension.
  #
  # @param file_path [String] the path of the file.
  # @return [String] the MIME type for the file.
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