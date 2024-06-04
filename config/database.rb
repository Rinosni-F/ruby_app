# config/database.rb
require 'active_record'
require 'yaml'

class Database
  def self.client(env)
    db_config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(db_config[env])
  end
end
