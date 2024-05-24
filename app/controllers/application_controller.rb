require_relative '../../config/database'
require_relative '../../config/routes'
require_relative 'login_controller'
require_relative 'adduser_controller'
require_relative 'home_controller'


class ApplicationController
  def initialize(db_config)
    @client = Database.client(db_config)
    @routes = Routes.new(@client)
  end
  

  def call(env)
    @routes.call(env)
  end
end
