require_relative "route"

# Router class responsible for storing routes and
# finding the correct route for an incoming request.
#
# Routes are registered using HTTP methods such as
# GET and POST, and matched against incoming requests.
class Router
  # Initializes a new Router with an empty route collection.
  def initialize
    @routes = []
  end

  # Registers a GET route.
  #
  # @param path [String] the URL path pattern to match.
  # @yield the block executed when the route matches.
  # @return [void]
  def get(path, &block)
    add_route("GET", path, block)
  end

  # Registers a POST route.
  #
  # @param path [String] the URL path pattern to match.
  # @yield the block executed when the route matches.
  # @return [void]
  def post(path, &block)
    add_route("POST", path, block)
  end

  # Finds the first route that matches the incoming request.
  #
  # Iterates through all registered routes and returns the first
  # route whose method and path pattern match the request.
  #
  # @param request [Request] the incoming HTTP request.
  # @return [Route, nil] the matching route or nil if none match.
  def match(request)
    @routes.find { |route| route.match?(request) }
  end

  private

  # Adds a new route to the router.
  #
  # @param method [String] the HTTP method for the route.
  # @param path [String] the URL path pattern.
  # @param block [Proc] the block executed when the route matches.
  # @return [void]
  def add_route(method, path, block)
    @routes << Route.new(method, path, block)
  end
end