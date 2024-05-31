require 'bcrypt'

class AddUserController < ApplicationController
  
  def route_request(request)
    if request.post? && request.path == '/add_user'
      handle_form_submission(request)
    else
      render_add_user_form
    end
  end

  private

  def handle_form_submission(request)
    username = request.params['username']
    email = request.params['email']
    password = BCrypt::Password.create(request.params['password'])
    role = request.params['role']


    if insert_user(username, email, password, role)
      redirect_to_index_with_message('User added successfully!')
    end
  end

  def insert_user(username, email, password, role)
    query = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)"
    statement = @client.prepare(query)
    statement.execute(username, email, password, role)
    true # Return true to indicate success
  rescue StandardError => e
    puts "Error inserting user: #{e.message}" # Log the error message
    false # Return false to indicate failure
  end
  
  def render_add_user_form
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/adduser.html.erb')
    [200, headers, [response]]
  end

  def redirect_to_index_with_message(message)
    @success_message = message
    @users = fetch_all_users_with_roles
    render_user_list
  end

  def fetch_all_users_with_roles
    query = "SELECT id, username, email, role FROM users"
    statement = @client.prepare(query)
    result = statement.execute.to_a
    puts "Fetched Users: #{result.inspect}" # Debugging line
    result
  end
  def render_user_list
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
end
