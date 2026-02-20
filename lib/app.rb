require_relative 'tcp_server'
require_relative 'application'

app = Application.new

app.get "/" do |req|
  #"<h1>Root side not found!</h1>"
  erb :home
end

app.get "/hello" do |req|
  "<h1>Hello, World!</h1>"
  #erb :hello, name: "World"
end

app.get "/test" do |req|
  "<h1>Hello, World2!</h1>"
  #erb :index
end

server = HTTPServer.new(4567, app)
server.start