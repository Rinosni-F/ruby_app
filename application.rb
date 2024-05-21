require_relative 'database'
require_relative 'login_form_handler'

class Application
  def initialize(db_config)
    @client = Database.client(db_config)
  end

  def call(env)
    LoginFormHandler.new(@client).call(env)
  end
end
