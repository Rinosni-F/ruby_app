require_relative 'login_controller' # Adjusted path
require_relative '../models/database' # Adjust the path based on your directory structure

class ApplicationController
  def initialize(db_config)
    @client = Database.client(db_config)
  end

  def call(env)
    LoginController.new(@client).call(env)
  end
end
