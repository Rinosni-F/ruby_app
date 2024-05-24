require 'bcrypt'

class User
  attr_accessor :username, :email, :password, :role

  def initialize(username:, email:, password:, role:)
    @username = username
    @password = BCrypt::Password.create(password) # Hashing the password
    @role = role
  end

  def save_to_db(database)
    query = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)"
    statement = database.prepare(query)
    statement.execute(username, email, password, role)
  end
end
