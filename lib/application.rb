require_relative 'router'
require_relative 'response'
require 'erb'

class Application
  def initialize
    @router = Router.new
  end

  def get(path, &block)
    @router.get(path, &block)
  end

  def post(path, &block)
    @router.post(path, &block)
  end

  def call(request)
    route = @router.match(request)

    if route
      body = instance_exec(request, &route[:block])
      Response.new(status: 200, body: body)
    else
      Response.new(status: 404, body: "Not Found")
    end
  end

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

  # doesn't work, it should yield views from layout
  def erb2(template_name, locals = {}, layout: true)
    views_path = File.join(Dir.pwd, "views")
    p views_path
    file_path  = File.join(views_path, "#{template_name}.erb")
    p template_name

    template = ERB.new(File.read(file_path))

    locals.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    content = template.result(binding)

    return content unless layout

    layout_path = File.join(views_path, "layout.erb")
    layout_template = ERB.new(File.read(layout_path))

    layout_template.result(binding { content })
  end
end