require 'mysql2'
require 'yaml'
require 'erb'

class Database
  def self.client(env = 'development')
    db_config = YAML.safe_load(ERB.new(File.read('config/database.yml')).result, aliases: true)[env]

    Mysql2::Client.new(
      host: db_config['host'],
      username: db_config['username'],
      password: db_config['password'],
      database: db_config['database'],
      encoding: db_config['encoding']
    )
  end
  query = <<~SQL
  CREATE TABLE IF NOT EXISTS tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    booking_date DATE NOT NULL,
    bus_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL
  )
SQL
create_passengers_table = <<~SQL
CREATE TABLE IF NOT EXISTS passengers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  mobile VARCHAR(15) NOT NULL,
  age INT NOT NULL
)
SQL

client.query(create_passengers_table)

end
