require 'bcrypt'

class LoginController < ApplicationController
  def route_request(request)
    if request.post? && request.path == '/submit'
      handle_form_submission(request)
    elsif request.get? && request.path == '/home'
      @users = fetch_all_users_with_roles
      render_user_list
    elsif request.get? && request.path.start_with?('/edit_user/')
      user_id = request.path.split('/').last.to_i
      @user = fetch_user_by_id(user_id)
      render_edit_page
    elsif request.post? && request.path == '/logout'
      render_login_form
    else
      render_login_form
    end
  end

  private

  def handle_form_submission(request)
    username = request.params['username']
    password = request.params['password']

    if valid_user?(username, password)
      redirect_to_index_with_message('Login successful')
    else
      redirect_to_index_with_failure_message('Login failed')
    end
  end
  def fetch_user_by_id(user_id)
    query = "SELECT id, username, email, role FROM users WHERE id = ?"
    statement = @client.prepare(query)
    statement.execute(user_id).first
  end

  def redirect_to_index_with_message(message)
    @success_message = message
    @users = fetch_all_users_with_roles
    render_user_list
  end

  def redirect_to_index_with_failure_message(message)
    @failure_message = message
    render_login_form
  end
  def fetch_all_users_with_roles
    query = "SELECT id, username, email, role FROM users"
    statement = @client.prepare(query)
    statement.execute.to_a
  end
  def render_user_list
    headers = {'Content-Type' => 'text/html'}
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
  def valid_user?(username, password)
    query = "SELECT password FROM users WHERE username = ? LIMIT 1"
    statement = @client.prepare(query)
    result = statement.execute(username).first
    return false unless result
    hashed_password = result['password']
    BCrypt::Password.new(hashed_password) == password
  end

  def render_login_form
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/login/login_home.html.erb')
    # Append failure message if it exists
  if @failure_message
    response += %(
      <div class="container center alert alert-danger">
        #{@failure_message}
      </div>
    )
  end
    [200, headers, [response]]
  end

  def render_edit_page
    headers = {'Content-Type' => 'text/html'}
    erb_file = File.read('app/views/home/edit.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
end
