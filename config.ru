require_relative 'config/database'
require_relative 'config/routes'
require_relative 'app/controllers/application_controller'
require_relative 'app/controllers/login_controller'
require_relative 'app/controllers/adduser_controller'
require_relative 'app/controllers/home_controller'


db_config = 'development' # Adjust according to your environment
client = Database.client(db_config)

routes = Routes.new(client)

run routes

