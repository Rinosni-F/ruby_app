require 'rack'
require 'bcrypt'

class LoginController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.post? && request.path == '/submit'
      @users = fetch_all_users_with_roles
      render_user_list
    elsif request.get? && request.path == '/home'
      reload_current_page
    else
      render_login_form
    end
  end

  private

  def handle_form_submission(request)
    username = request.params['username']
    password = request.params['password']

    if valid_user?(username, password)
      render_success_message
    else
      render_failure_message
    end
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
    [200, headers, [response]]
  end

  def render_success_message
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/show.html.erb')
    [200, headers, [response]]
  end
  

  def render_failure_message
    headers = {'Content-Type' => 'text/html'}
    response = modify_html('failure-message')
    [200, headers, [response]]
  end

  def modify_html(section_id)
    html = File.read('app/views/login/login_home.html.erb')
    html.gsub!(%r{id="login-form" class="center"}, 'id="login-form" class="center hidden"')
    html.gsub!(%r{id="#{section_id}" class="center hidden"}, 'id="#{section_id}" class="center"')
    html
  end
  def reload_current_page
    headers = { 'Content-Type' => 'text/html' }
    body = '<html><head><meta http-equiv="refresh" content="0"></head></html>' # Refresh the page
    [200, headers, [body]]
  end
end
