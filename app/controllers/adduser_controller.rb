class Adduser 

        def index(env)
            headers = {'Content-Type' => 'text/html'}
            response = File.read('app/views/home/adduser.html')
            [200, headers, [response]]
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
            # Extract form data
            username = request.params['username']
            email = request.params['email']
            password = request.params['password']
        
            # Insert user data into the database
            insert_user(username, email, password)
        
            # Redirect to a success page or display a success message
            [302, {'Location' => '/success'}, []]
          end
        
          def insert_user(username, email, password)
            # Establish a connection to the database
            # For simplicity, assuming you already have a database connection setup
        
            # Prepare and execute SQL query to insert user data
            query = "INSERT INTO user (username, email, password) VALUES (?, ?, ?)"
            statement = @client.prepare(query)
            statement.execute(username, email, password)
          end
        
          def render_add_user_form
            headers = {'Content-Type' => 'text/html'}
            response = File.read('app/views/home/adduser.html')
            [200, headers, [response]]
          end
end

  