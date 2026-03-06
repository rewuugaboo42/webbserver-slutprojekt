# Route class representing a single route in the router.
# It stores the HTTP method, path pattern, and the block
# of code to execute when a request matches the route.
class Route
  # @return [String] the HTTP method this route responds to (e.g., GET, POST).
  attr_reader :method

  # Initializes a new Route.
  #
  # Converts dynamic segments in the path (e.g. `/users/:id`)
  # into a regular expression pattern and stores the parameter keys.
  #
  # @param method [String] the HTTP method for the route.
  # @param path [String] the path pattern for the route.
  # @param block [Proc] the block executed when the route matches.
  def initialize(method, path, block)
    @method = method
    @block  = block
    @keys   = []

    pattern = path.gsub(/:\w+/) do |match|
      @keys << match[1..]
      "([^/]+)"
    end

    @pattern = /^#{pattern}$/
  end

  # Checks whether a request matches this route.
  #
  # A match occurs if both the HTTP method and the path pattern match.
  #
  # @param request [Request] the incoming request.
  # @return [Boolean] whether the request matches this route.
  def match?(request)
    return false unless request.method == method
    !!@pattern.match(request.path)
  end

  # Extracts route parameters from the given path.
  #
  # For example, with route `/users/:id` and path `/users/42`,
  # it returns `{ "id" => "42" }`.
  #
  # @param path [String] the request path.
  # @return [Hash{String => String}] the extracted route parameters.
  def params(path)
    match = @pattern.match(path)
    return {} unless match

    params = {}

    @keys.each_with_index do |key, i|
      params[key] = match.captures[i]
    end

    params
  end

  # Executes the route block when the route matches.
  #
  # The extracted route parameters are passed as arguments
  # to the route block.
  #
  # @param app [Application] the application instance executing the route.
  # @param request [Request] the incoming request.
  # @return [Object] the result returned by the route block.
  def call(app, request)
    route_params = params(request.path)
    args = @keys.map { |k| route_params[k] }

    app.instance_exec(*args, &@block)
  end
end