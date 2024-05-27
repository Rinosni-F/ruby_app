class HomeController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    if request.get? && request.path.match(%r{/edit_user/\d+}) # Match paths like /edit_user/123
    @users = fetch_all_users_with_roles
      render_edit_page
    else
      render_user_list
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
    erb_file = File.read('app/views/home/index.html.erb')
    template = ERB.new(erb_file)
    response = template.result(binding)
    [200, headers, [response]]
  end

  def render_edit_page
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/edit.html.erb')
    [200, headers, [response]]
  end
end
