# config.ru

require 'active_record'
require 'yaml'
require_relative 'config/routes'
require_relative 'app/controllers/application_controller'
require_relative 'app/controllers/login_controller'
require_relative 'app/controllers/adduser_controller'
require_relative 'app/controllers/home_controller'
require_relative 'app/controllers/tickets_controller'

# Load database configuration
# db_config = YAML.safe_load(ERB.new(File.read('config/database.yml')).result, aliases: true)[env]

db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(db_config['development'])

# Initialize routes
routes = Routes.new(ActiveRecord::Base.connection)

# Run the application
run routes
