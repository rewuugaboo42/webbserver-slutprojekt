require_relative 'spec_helper'
require_relative '../lib/request'
require_relative '../lib/get_request'
require_relative '../lib/post_request'

class RequestTest < Minitest::Test

  def test_parses_http_method_from_simple_get
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    assert_equal 'GET', request.method
  end

  def test_parses_resource_from_simple_get
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    assert_equal '/', request.resource
  end

  def test_parses_version_from_simple_get
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    assert_equal 'HTTP/1.1', request.version
  end

  def test_parses_headers_from_simple_get
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    expected = {
      'Host' => 'developer.mozilla.org',
      'Accept-Language' => 'fr'
    }

    assert_equal expected, request.headers
  end

  def test_parses_params_from_simple_get
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    expected = {}

    assert_equal expected, request.params
  end

  def test_parses_is_cached
    request_string = File.read('get-index.request.txt')
    request = Request.build(request_string)

    headers1 = request.headers
    headers2 = request.headers

    assert_equal headers1, headers2
  end
end