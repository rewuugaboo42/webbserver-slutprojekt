# Response class which represents an HTTP response sent from the server
# back to the client. It formats the HTTP status line, headers, and body
# into a valid HTTP response string.
class Response
  # Mapping of HTTP status codes to their standard messages.
  #
  # @return [Hash{Integer => String}] the HTTP status descriptions.
  STATUS = {
    200 => "OK",
    404 => "NOT FOUND",
    500 => "INTERNAL SERVER ERROR"
  }

  # Initializes a new Response object.
  #
  # @param status [Integer] the HTTP status code (default: 200).
  # @param body [String] the body content of the response.
  # @param headers [Hash] optional additional HTTP headers.
  def initialize(status: 200, body: "", headers: {})
    @status = status
    @body = body
    @headers = {
      "Content-Type" => "text/html",
      "Content-Length" => body.bytesize
    }.merge(headers)
  end

  # Converts the Response object into a valid HTTP response string
  # which can be sent directly over a TCP socket.
  #
  # @return [String] the complete HTTP response string including
  #   status line, headers, and body.
  def to_s
    response = +"HTTP/1.1 #{@status} #{STATUS[@status]}\r\n"

    @headers.each do |key, value|
      response << "#{key}: #{value}\r\n"
    end

    response << "\r\n"
    response << @body
    response
  end
end