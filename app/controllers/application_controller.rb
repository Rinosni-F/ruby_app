require 'rack'
require 'json'
require 'erb'

class ApplicationController
  def initialize(client)
    @client = client
  end

  protected

  def redirect_to(path)
    [302, {'Location' => path}, []]
  end
end
