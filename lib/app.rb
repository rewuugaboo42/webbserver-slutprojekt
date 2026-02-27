require_relative 'tcp_server'
require_relative 'application'

app = Application.new

app.get "/" do |request|
  #"<h1>Root side not found!</h1>"
  erb :home
end

app.get "/hello" do |request|
  p "//////////////////////////////////////////////////////"
  p "/hello"
  erb :hello
end

app.get "/about" do |request|
  erb :home
end

#body = route.block.call(request.params)
# /add/2/5
app.get "/add/:num1/:num2" do |num1, num2| 
  sum = num1.to_i + num2.to_i
  puts sum
end

app.post "/hello" do |request|
  p request.method
  p request.resource
  p request.version
  p request.headers
  p request.params
  erb :hello, { name: request.params["name"] }
end

app.get "/test" do |request|
  erb :index
end

server = HTTPServer.new(4567, app)
server.start