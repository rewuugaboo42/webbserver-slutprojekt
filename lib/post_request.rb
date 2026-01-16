require_relative 'request'

class PostRequest < Request
  def parse_params
    @params = {}

    return if body.empty?

    @params = parse_key_value_pairs(body)
  end
end