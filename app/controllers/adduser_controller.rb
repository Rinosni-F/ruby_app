require 'bcrypt'

class AddUserController
  def initialize(client)
    @client = client
  end

  def call(env)
    request = Rack::Request.new(env)

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

    if insert_user(username, email, password)
      render_success_message
    else
      render_failure_message
    end
  end

  def insert_user(username, email, password)
    query = "INSERT INTO user (username, email, password) VALUES (?, ?, ?)"
    statement = @client.prepare(query)
    statement.execute(username, email, password)
    true # Return true to indicate success
  rescue StandardError => e
    puts "Error inserting user: #{e.message}" # Log the error message
    false # Return false to indicate failure
  end

  def render_add_user_form
    headers = {'Content-Type' => 'text/html'}
    response = File.read('app/views/home/adduser.html')
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
    html = File.read('app/views/home/adduser.html')
    html.gsub!(%r{id="login-form" class="center"}, 'id="login-form" class="center hidden"')
    html.gsub!(%r{id="success-message" class="center hidden"}, 'id="success-message" class="center"') if section_id == 'success-message'
    html.gsub!(%r{id="failure-message" class="center hidden"}, 'id="failure-message" class="center"') if section_id == 'failure-message'
    html
  end
end
