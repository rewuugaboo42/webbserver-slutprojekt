require 'cgi'

class Request
  attr_reader :method, :resource, :version, :headers, :params, :path, :query_string

  def self.build(request_string)
    method = request_string.lines.first.split.first

    case method
    when 'GET'
      GetRequest.new(request_string)
    when 'POST'
      PostRequest.new(request_string)
    else
      new(request_string)
    end
  end

  def initialize(request_string)
    @request_string = request_string
    parse
  end

  private

  def parse
    parse_request_line
    parse_headers
    parse_params
  end

  def parse_request_line
    request_line = lines.first.strip
    @method, full_resource, @version = request_line.split(' ')

    if full_resource.include?('?')
      @path, @query_string = full_resource.split('?', 2)
    else
      @path = full_resource
      @query_string = nil
    end

    @resource = @path
  end

  def parse_headers
    @headers = {}

    header_lines.each do |line|
      key, value = line.split(':', 2)
      @headers[key] = value.strip
    end
  end

  def parse_params
    @params = {}

    if @query_string && !@query_string.empty?
      @params.merge!(parse_key_value_pairs(@query_string))
    end

    if @method == "POST" && !body.empty?
      @params.merge!(parse_key_value_pairs(body))
    end
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

      decoded_key   = CGI.unescape(key || "")
      decoded_value = CGI.unescape(value || "")

      hash[decoded_key] = decoded_value
    end
  end
end