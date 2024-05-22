require 'mysql2'

class Database
  def self.client(db_config)
    Mysql2::Client.new(db_config)
  end
end
