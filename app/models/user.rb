class User
    attr_accessor :username, :email, :password
  
    def initialize(username:, email:, password:)
      @username = username
      @email = email
      @password = password
    end
  
    def save_to_db(database)
      query = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)"
      statement = database.prepare(query)
      statement.execute(username, email, password)
    end
  end
  