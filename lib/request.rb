class Request
  def self.build(request_string)
    method = request_string.lines.first.split.first

    case method
    when 'GET'
      GetRequest.new(request_string)
    when 'POST'
      PostRequest.new(request_string)
    end
  end

  def initialize(request_string)
    @request_string = request_string
    parse
  end

  def method
    @method
  end
  
  def resource
    @resource
  end

  def version
    @version
  end

  def headers
    @headers
  end

  def params
    @params
  end

  private

  def parse
    parse_request_line
    parse_headers
    parse_params
  end

  def parse_request_line
    request_line = lines.first.strip
    @method, @resource, @version = request_line.split(' ')
  end

  def parse_headers
    @headers = {}

    header_lines.each do |line|
      key, value = line.split(':', 2)
      @headers[key] = value.strip
    end
  end

  def parse_params
    raise NotImplementedError
  end

  def lines 
    @lines ||= @request_string.lines
  end

  def header_lines
    lines[1..].take_while { |line| !line.strip.empty? }
  end

  def body
    blank = lines.index { |l| l.strip.empty? }
    blank ? lines[(blank + 1)..].join : ''
  end

  def parse_key_value_pairs(string)
    string.split('&').each_with_object({}) do |pair, hash|
      key, value = pair.split('=', 2)
      hash[key] = value.strip
    end
  end
end