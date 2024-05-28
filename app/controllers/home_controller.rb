class HomeController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.get? && request.path.start_with?('/edit_user')
      @users = fetch_all_users_with_roles
      render_edit_page
    else
      @users = fetch_all_users_with_roles
      render_user_list
    end
  end

  private

  def fetch_all_users_with_roles
    query = "SELECT id, username, email, role FROM users"
    statement = @client.prepare(query)
    result = statement.execute.to_a
    puts "Fetched Users: #{result.inspect}" # Debugging line
    result
  end

  def render_user_list
    headers = {'Content-Type' => 'text/html'}
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
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
