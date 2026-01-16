require_relative 'lib/request'
require_relative 'lib/get_request'
require_relative 'lib/post_request'

request_string = File.read('get-index.request.txt')

request = Request.build(request_string)

p request.method   #=> 'GET'
p request.resource #=> '/'
p request.version  #=> 'HTTP/1.1'
p request.headers  #=> {'Host' => 'developer.mozilla.org', 'Accept-Language' => 'fr'}
p request.params   #=> {}



request_string = File.read('get-examples.request.txt')

request = Request.build(request_string)

p request.method   #=> 'GET'
p request.resource #=> '/examples'
p request.version  #=> 'HTTP/1.1'
p request.headers  #=> {'Host' => 'example.com', 
#                       'User-Agent' => 'ExampleBrowser/1.0',
#                       'Accept-Encoding' => 'gzip, deflate',
#                       'Accept' => '*/*'}
p request.params   #=> {}



request_string = File.read('get-fruits-with-filter.request.txt')

request = Request.build(request_string)

p request.method   #=> 'GET'
p request.resource #=> '/fruits?type=bananas&minrating=4'
p request.version  #=> 'HTTP/1.1'
p request.headers  #=> {'Host' => 'fruits.com', 
#                       'User-Agent' => 'ExampleBrowser/1.0',
#                       'Accept-Encoding' => 'gzip, deflate',
#                       'Accept' => '*/*'}
p request.params   #=> {'type' => 'bananas', 'minrating' => '4'}



request_string = File.read('post-login.request.txt')

request = Request.build(request_string)

p request.method   #=> 'POST'
p request.resource #=> '/login'
p request.version  #=> 'HTTP/1.1'
p request.headers  #=> {'Host' => 'foo.example',
#                       'Content-Type' => 'application/x-www-form-urlencoded',
#                       'Content-Length' => '39'}
p request.params   #=> {'username' => 'grillkorv', 'password' => 'verys3cret!'}