require 'bcrypt'
require_relative '../models/user'

class AddUserController < ApplicationController
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
      render_user_list   
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

  def edit_user(request)
    user_id = request.path.split('/').last.to_i
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

      def update_user(request)
      user_id = request.path.split('/').last.to_i
      @user = User.find_by(id: user_id)

      if @user.update(
        username: request.params['username'],
        email: request.params['email'],
        role: request.params['role']
      )
        redirect_to "/users/#{@user.id}"
      else
        @error_message = 'Failed to update user.'
        edit_user(request)
      end
    end

    def render_user_list
      @users = User.all

      erb_file = File.read('app/views/home/user_list.html.erb')
      template = ERB.new(erb_file)
      response_body = template.result(binding)

      headers = { 'Content-Type' => 'text/html' }
      [200, headers, [response_body]]
    end
    def delete_user(request)
      user_id = request.path.split('/').last.to_i
      @user = User.find_by(id: user_id)

      if @user && @user.destroy
        redirect_to '/users'
      else
        not_found_response
      end
    end
  def not_found_response
    headers = { 'Content-Type' => 'text/plain' }
    [404, headers, ['User not found']]
  end
end
