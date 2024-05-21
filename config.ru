require 'rack'
require_relative 'application'
require_relative 'login_form_handler'
require_relative 'database'


use Rack::Reloader, 0

run Application.new(DB_CONFIG)
