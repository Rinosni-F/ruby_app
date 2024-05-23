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
      when '/app/views/home/adduser.html'
        Adduser.new.index(env)
      when '/add_user'
        Adduser.new(@client).call(env)
        # Add more routes here
      else
        not_found
      end
    end
  
    private
  
    def not_found
      [404, {'Content-Type' => 'text/html'}, ['Page Not Found']]
    end
  end
  