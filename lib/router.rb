class Router
  def initialize
    @routes = []
  end

  def get(path, &block)
    @routes << { method: "GET", path: path, block: block }
  end

  def post(path, &block)
    @routes << { method: "POST", path: path, block: block }
  end

  def match(request)
    @routes.find do |route|
      route[:method] == request.method &&
      route[:path] == request.resource
    end
  end
end