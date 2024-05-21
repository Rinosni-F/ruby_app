require 'mysql2'

DB_CONFIG = {
    host: 'localhost',
    username: 'root',
    password: 'rino',
    database: 'indexing',
    port: 3306 # Default MySQL 
}

class Database
  def self.client(db_config)
    Mysql2::Client.new(db_config)
  end
end
