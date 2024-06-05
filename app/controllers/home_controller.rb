class HomeController  < ApplicationController

  # def route_request(request)
  #   if request.post? && request.path.start_with?('/update_user/')  # Handle update user request
  #     user_id = request.path.split('/').last.to_i
  #     update_user(user_id, request.params)
  #     return redirect_to_index_with_message('User updated successfully!')
  #   elsif request.get? && request.path.start_with?('/delete_user/')
  #     user_id = request.path.split('/').last.to_i
  #     delete_user(user_id)
  #     return redirect_to_index_with_message('User deleted successfully!')
  #   end
  # end


  def delete_user(user_id)
    query = "DELETE FROM users WHERE id = ?"
    user = @client.prepare(query)
    user.execute(user_id)
  end

  def fetch_all_users_with_roles
    query = "SELECT id, username, email, role FROM users"
    user = @client.prepare(query)
    result = user.execute.to_a
    puts "Fetched Users: #{result.inspect}" # Debugging line
    result
  end

  def update_user(user_id, params)
    query = "UPDATE users SET username = ?, email = ?, role = ? WHERE id = ?"
    user = @client.prepare(query)
    user.execute(params['username'], params['email'], params['role'], user_id)
  end

  def render_user_list
    headers = { 'Content-Type' => 'text/html' }
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def redirect_to_index_with_message(message)
    @success_message = message
    @users = fetch_all_users_with_roles
    render_user_list
  end
end
