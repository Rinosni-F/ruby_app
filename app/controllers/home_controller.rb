class HomeController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.get? && request.path == '/'
      @users = fetch_all_users_with_roles
      render_user_list
    else
      render_add_user_form
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
    response = erb_file('index.html.erb').result(binding)
    [200, headers, [response]]
  end

  def render_add_user_form
    headers = {'Content-Type' => 'text/html'}
    response = erb_file('add_user_form.html.erb').result(binding)
    [200, headers, [response]]
  end

  def erb_file(file_name)
    ERB.new(File.read("app/views/#{file_name}"))
  end
end
