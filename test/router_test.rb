require_relative 'spec_helper'
require_relative '../lib/request'
require_relative '../lib/get_request'
require_relative '../lib/post_request'
require_relative '../lib/router'

class RouterTest < Minitest::Test
  def test_router_is_cached
    @router = Router.new

    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    route = @router.match(request)

    assert_equal request.method, route[:method]
    assert_equal request.resource, route[:path]
  end
end