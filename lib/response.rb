class Response
  STATUS = {
    200 => "OK",
    404 => "NOT FOUND",
    500 => "INTERNAL SERVER ERROR"
  }

  def initialize(status: 200, body: "", headers: {})
    @status = status
    @body = body
    @headers = {
      "Content-Type" => "text/html",
      "Content-Length" => body.bytesize
    }.merge(headers)
  end

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