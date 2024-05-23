require 'mysql2'
require 'yaml'
require 'erb'

class Database
  def self.client(env = 'development')
    db_config = YAML.safe_load(ERB.new(File.read('config/database.yml')).result, aliases: true)[env]
    raise "Database configuration not found for environment: #{env}" if db_config.nil?
  
    Mysql2::Client.new(
      host: db_config['host'],
      username: db_config['username'],
      password: db_config['password'],
      database: db_config['database'],
      encoding: db_config['encoding']
    )
  end
  
end

# Usage example:
db = Database.client('development')

def create_user_table(db)
  db.query <<-SQL
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTO_INCREMENT,
      username TEXT,
      email TEXT,
      password TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
end


# Call the method to create the user table
create_user_table(db)
