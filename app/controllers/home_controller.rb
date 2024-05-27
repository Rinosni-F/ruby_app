class HomeController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.get? && request.path == '/home'
      @users = fetch_all_users_with_roles
      render_user_list
    else
      # render_add_user_form
    end
  end

  private

  def fetch_all_users_with_roles
    query = "SELECT id, username, email, role FROM users"
    statement = @client.prepare(query)
    statement.execute.to_a
  end

  def render_user_list
    headers = {'Content-Type' => 'text/html'}
    erb_file = File.read('app\views\home\index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end
  
  
end
