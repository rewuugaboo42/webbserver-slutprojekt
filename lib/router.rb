class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def get(path, &block)
    @routes << {
      method: "GET",
      path: path,
      block: block
    }
  end

  def match(request)
    @routes.find do |route|
      route[:method] == request.method &&
      route[:path] == request.resource
    end
  end
end