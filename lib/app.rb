require_relative 'tcp_server'
require_relative 'application'

app = Application.new

app.get "/" do |request|
  #"<h1>Root side not found!</h1>"
  erb :home
end
#snygtt jobbat // malte ostling
app.get "/hello" do |request|
  erb :hello
end

app.get "/add/:num1/:num2" do |num1, num2| 
  sum = num1.to_i + num2.to_i
  puts sum
  redirect "/"
end

app.get "/fps" do |request|
  erb :fps
end

app.post "/hello" do |request|
  erb :hello, { name: request.params["name"] }
end

app.get "/test" do |request|
  erb :index
end

server = HTTPServer.new(4567, app)
server.start