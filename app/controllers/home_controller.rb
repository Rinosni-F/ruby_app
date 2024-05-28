class HomeController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.post? && request.path.start_with?('/update_user/')  # Handle update user request
      user_id = request.path.split('/').last.to_i
      @user = fetch_user_by_id(user_id)
      update_user(user_id, request.params)
      return redirect_to_index_with_message
    end
  end

  private

  def update_user(user_id, params)
    query = "UPDATE users SET username = ?, email = ?, role = ? WHERE id = ?"
    statement = @client.prepare(query)
    statement.execute(params['username'], params['email'], params['role'], user_id)
  end

  def fetch_user_by_id(user_id)
    query = "SELECT id, username, email, role FROM users WHERE id = ?"
    statement = @client.prepare(query)
    statement.execute(user_id).first
  end

  def redirect_to_index_with_message
    headers = { 'Content-Type' => 'text/html', 'Location' => '/home' }
    response = File.read('app/views/home/index.html.erb')
    [302, headers, [response]]
  end

end
