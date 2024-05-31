require 'rack'
require 'json'
require 'erb'

class ApplicationController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    route_request(request)
  end

  protected

  def redirect_to(path)
    [302, {'Location' => path}, []]
  end
end
