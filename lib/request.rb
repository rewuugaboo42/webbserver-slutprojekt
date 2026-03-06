require 'cgi'

# Base class representing an HTTP request.
# Responsible for parsing raw HTTP request strings,
# extracting method, path, headers, and parameters.
class Request
  attr_reader :method, :resource, :version, :headers, :params, :path, :query_string

  # Factory method to build the appropriate Request subclass
  # based on the HTTP method in the raw request string.
  #
  # @param request_string [String] the raw HTTP request string.
  # @return [Request, GetRequest, PostRequest] the parsed request object.
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

  # Initializes a new Request object.
  #
  # @param request_string [String] the raw HTTP request string.
  def initialize(request_string)
    @request_string = request_string
    parse
  end

  private

  # Parses the request string into request line, headers, and parameters.
  #
  # @return [void]
  def parse
    parse_request_line
    parse_headers
    parse_params
  end

  # Parses the request line to extract method, resource, and HTTP version.
  #
  # Also separates path and query string if present.
  #
  # @return [void]
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

  # Parses HTTP headers from the request string into a hash.
  #
  # @return [void]
  def parse_headers
    @headers = {}

    header_lines.each do |line|
      key, value = line.split(':', 2)
      @headers[key] = value.strip
    end
  end

  # Parses query parameters (for GET) and body parameters (for POST)
  # into the @params hash.
  #
  # @return [void]
  def parse_params
    @params = {}

    if @query_string && !@query_string.empty?
      @params.merge!(parse_key_value_pairs(@query_string))
    end

    if @method == "POST" && !body.empty?
      @params.merge!(parse_key_value_pairs(body))
    end
  end

  # Splits the raw request string into lines.
  #
  # @return [Array<String>] the lines of the request.
  def lines
    @lines ||= @request_string.lines
  end

  # Returns only the header lines from the request.
  #
  # @return [Array<String>] the header lines.
  def header_lines
    lines[1..].take_while { |line| !line.strip.empty? }
  end

  # Extracts the body of the request (for POST data).
  #
  # @return [String] the request body.
  def body
    blank = lines.index { |l| l.strip.empty? }
    blank ? lines[(blank + 1)..].join : ''
  end

  # Parses a query string or body string into key-value pairs.
  #
  # @param string [String] the query string or body string.
  # @return [Hash{String => String}] the parsed parameters.
  def parse_key_value_pairs(string)
    string.split('&').each_with_object({}) do |pair, hash|
      key, value = pair.split('=', 2)

      decoded_key   = CGI.unescape(key || "")
      decoded_value = CGI.unescape(value || "")

      hash[decoded_key] = decoded_value
    end
  end
end