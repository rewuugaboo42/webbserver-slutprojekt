require_relative 'request'

# Represents a POST HTTP request.
# Inherits from Request and specializes in handling
# parameters sent in the request body.
class PostRequest < Request
  # Parses parameters from the request body.
  #
  # If the request body is not empty, it splits the body
  # into key-value pairs and stores them in the @params hash.
  #
  # @return [void]
  def parse_params
    @params = {}

    return if body.empty?

    @params = parse_key_value_pairs(body)
  end
end