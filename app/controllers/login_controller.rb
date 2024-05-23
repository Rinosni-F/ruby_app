require 'rack'
require 'bcrypt'

class LoginController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.post? && request.path == '/submit'
      handle_form_submission(request)
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
    response = File.read('app/views/login/login_home.html')
    [200, headers, [response]]
  end

  def render_success_message
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/index.erb')
    [200, headers, [response]]
  end
  

  def render_failure_message
    headers = {'Content-Type' => 'text/html'}
    response = modify_html('failure-message')
    [200, headers, [response]]
  end

  def modify_html(section_id)
    html = File.read('app/views/login/login_home.html')
    html.gsub!(%r{id="login-form" class="center"}, 'id="login-form" class="center hidden"')
    html.gsub!(%r{id="#{section_id}" class="center hidden"}, 'id="#{section_id}" class="center"')
    html
  end
end
