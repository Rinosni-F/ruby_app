require 'bcrypt'
require_relative '../models/user'

class AddUserController < ApplicationController
  # def route_request(request)
  #   if request.post? && request.path == '/add_user'
  #     handle_form_submission(request)
  #   elsif request.get? && request.path.match('/users/')
  #     show_user(request)
  #   elsif request.get? && request.path == '/edit_user'
  #     edit_user(request)
  #   else
  #     render_add_user_form
  #   end
  # end

  # private

  def handle_form_submission(request)
    @success_message = nil
    @error_message = nil
    @user = User.new(
      username: request.params['username'],
      email: request.params['email'],
      password_digest: BCrypt::Password.create(request.params['password']),
      role: request.params['role']
    )
    if @user.save
      redirect_to "/users/#{@user.id}"
    else
      @error_message = 'Failed to add user.'
      render_add_user_form
    end
  end

  def show_user(request)
    user_id = request.path.split('/').last.to_i
    @user = User.find_by(id: user_id)
    
    if @user
      render_show_user
    else
      not_found_response
    end
  end

  def render_show_user
    erb_file = File.read('app/views/home/show.html.erb')
    template = ERB.new(erb_file)
    response_body = template.result(binding)

    # Add an edit link to the response body
    # response_body += "<a href='/edit_user?user_id=#{@user.id}' class='btn btn-primary'>Edit</a>"

    headers = { 'Content-Type' => 'text/html' }
    [200, headers, [response_body]]
  end

  def render_add_user_form
    @error_message ||= nil
    @success_message ||= nil
    erb_file = File.read('app/views/home/adduser.html.erb')
    template = ERB.new(erb_file)
    response_body = template.result(binding)

    headers = { 'Content-Type' => 'text/html' }
    [200, headers, [response_body]]
  end

  def not_found_response
    headers = { 'Content-Type' => 'text/plain' }
    [404, headers, ['User not found']]
  end

  def edit_user(request)
    user_id = request.params['user_id']
    @user = User.find_by(id: user_id)
    
    if @user
      erb_file = File.read('app/views/home/edit.html.erb')
      template = ERB.new(erb_file)
      response_body = template.result(binding)

      headers = { 'Content-Type' => 'text/html' }
      [200, headers, [response_body]]
    else
      not_found_response
    end
  end
end
