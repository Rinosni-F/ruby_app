require 'bcrypt'
require 'erb'


class LoginController < ApplicationController

  def handle_form_submission(request)
    username = request.params['username']
    password = request.params['password']

    if valid_user?(username, password)
      user = User.find_by(username: username)
      redirect_to_user_details(user.id, 'Login successful')
    else
      redirect_to_index_with_failure_message('Login failed')
    end
  end

  def valid_user?(username, password)
    user = User.find_by(username: username)
    return false unless user
    BCrypt::Password.new(user.password_digest) == password
  end

  def redirect_to_user_details(user_id, message)
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response_body = template.result(binding)
    headers = { 'Content-Type' => 'text/html' }
    [200, headers, [response_body]]
  end

  def redirect_to_index_with_failure_message(message)
    @failure_message = message
    render_login_form
  end

  def render_login_form
    erb_file = File.read('app/views/login/login_home.html.erb')
    template = ERB.new(erb_file)
    response_body = template.result(binding)
    headers = { 'Content-Type' => 'text/html' }
    [200, headers, [response_body]]
  end

  def render_home
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response_body = template.result(binding)
    headers = { 'Content-Type' => 'text/html' }
    [200, headers, [response_body]]
  end
end
