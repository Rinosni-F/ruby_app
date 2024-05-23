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
end

