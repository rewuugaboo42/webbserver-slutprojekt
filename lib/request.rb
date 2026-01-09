class Request

  def initialize(file_content)
    @file_content = file_content
    @split_content = file_content.split(' ')
    @method = @split_content.first
    @resource = @split_content[1]
    @version = @split_content[2]
    @headers = @split_content.drop(3)
  end

  def method
    @method
  end
  
  def resource
    @resource
  end

  def version
    @version
  end

  def headers
    @headers
  end

  def Params
    @params
  end
end

request_string = File.read('get-index.request.txt')
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers