require_relative 'request'

# Represents a GET HTTP request.
# Inherits from Request and specializes in handling
# query parameters in the URL.
class GetRequest < Request
  # Parses the query parameters from the request URL.
  #
  # If the resource path contains a query string (after '?'),
  # it splits the query string into key-value pairs and stores
  # them in the @params hash.
  #
  # @return [void]
  def parse_params
    @params = {}

    return unless resource.include?('?')

    _, query = resource.split('?', 2)
    @params = parse_key_value_pairs(query)
  end
end