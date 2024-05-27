class Routes
  def initialize(client)
    @client = client
  end

  def call(env)
    case env['PATH_INFO']
    when '/'
      LoginController.new(@client).call(env)
    when '/submit'
      LoginController.new(@client).call(env)
    when '/adduser'
      AddUserController.new(@client).call(env)
    when '/add_user'
      AddUserController.new(@client).call(env)
    when '/home'
      HomeController.new(@client).call(env)
    else
      not_found
    end
  end

  private

  def not_found
    [404, {'Content-Type' => 'text/html'}, ['Page Not Found']]
  end
end
