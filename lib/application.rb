require_relative 'router'
require_relative 'response'
require 'erb'

# Application class serves as the main entry point for the web application.
# It manages routes, handles requests, renders templates, and returns responses.
class Application
  # Initializes a new Application with a Router instance.
  def initialize
    @router = Router.new
  end

  # Defines a GET route and associates it with a block of code to execute.
  #
  # @param path [String] the URL path to match.
  # @yield [Application, Request] a block executed when the route is matched.
  # @return [void]
  def get(path, &block)
    @router.get(path, &block)
  end

  # Defines a POST route and associates it with a block of code to execute.
  #
  # @param path [String] the URL path to match.
  # @yield [Application, Request] a block executed when the route is matched.
  # @return [void]
  def post(path, &block)
    @router.post(path, &block)
  end

  # Handles an incoming request and returns an HTTP response.
  #
  # @param request [Request] the incoming request object.
  # @return [Response] the response to be sent to the client.
  def call(request)
    route = @router.match(request)

    return Response.new(status: 404, body: "Not Found") unless route

    result = route.call(self, request)

    if result.is_a?(Response)
      result
    else
      Response.new(status: 200, body: result.to_s)
    end
  end

  # Renders an ERB template with optional local variables and layout.
  #
  # @param template_name [String] the name of the template file (without .erb).
  # @param locals [Hash] local variables to be available in the template.
  # @param layout [Boolean] whether to wrap the template in layout.erb.
  # @return [String] the rendered HTML content.
  def erb(template_name, locals = {}, layout: true)
    views_path = File.join(Dir.pwd, "views")
    file_path  = File.join(views_path, "#{template_name}.erb")

    template = ERB.new(File.read(file_path))

    locals.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    content = template.result(binding)

    return content unless layout

    layout_path = File.join(views_path, "layout.erb")
    if File.exist?(layout_path)
      layout_template = ERB.new(File.read(layout_path))
      @content = content
      layout_template.result(binding)
    else
      content
    end
  end

  # Returns a redirect Response object.
  #
  # @param path [String] the URL path to redirect to.
  # @param status [Integer] the HTTP status code for the redirect (default 302).
  # @return [Response] the redirect response.
  def redirect(path, status = 302)
    Response.new(
      status: status,
      headers: { "Location" => path },
      body: ""
    )
  end
end