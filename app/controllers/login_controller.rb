require 'rack'

class LoginController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.post? && request.path == '/submit'
      handle_form_submission(request)
    elsif request.path == '/home'
      render_home_page
    else
      render_login_form
    end
  end

  private

  def handle_form_submission(request)
    username = request.params['username']
    password = request.params['password']

    if valid_user?(username, password)
      redirect_to_home
    else
      render_failure_message
    end
  end

  def valid_user?(username, password)
    query = "SELECT * FROM user WHERE username = ? AND password = ? LIMIT 1"
    statement = @client.prepare(query)
    result = statement.execute(username, password)
    result.count > 0
  end

  def render_login_form
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/login/login_home.html')
    [200, headers, [response]]
  end

  def render_success_message
    headers = {'Content-Type' => 'text/html'}
    response = modify_html('success-message')
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

  def redirect_to_home
    [302, { 'Location' => '/home' }, []]
  end

  def render_home_page
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/index.erb')
    [200, headers, [response]]
  end
end