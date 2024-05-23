require_relative '../models/user'
require 'bcrypt'

class UserFormHandler
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.post? && request.path == '/register'
      handle_user_creation(request)
    else
      render_registration_form
    end
  end

  private

  def handle_user_creation(request)
    username = request.params['username']
    password = request.params['password']

    if username && password
      User.create(@client, username, password)
      render_success_message
    else
      render_failure_message
    end
  end

  def render_registration_form
    headers = { 'Content-Type' => 'text/html' }
    response = File.read('views/users/register.html')
    [200, headers, [response]]
  end

  def render_success_message
    headers = { 'Content-Type' => 'text/html' }
    response = '<h1>Registration successful!</h1>'
    [200, headers, [response]]
  end

  def render_failure_message
    headers = { 'Content-Type' => 'text/html' }
    response = '<h1>Registration failed. Please try again.</h1>'
    [200, headers, [response]]
  end
end
