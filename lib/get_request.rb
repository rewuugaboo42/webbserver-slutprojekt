require_relative 'request'

class GetRequest < Request
  def parse_params
    @params = {}

    return unless resource.include?('?')

    _, query = resource.split('?', 2)
    @params = parse_key_value_pairs(query)
  end
end