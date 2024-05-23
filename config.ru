require 'rack'
require_relative 'app/controllers/application_controller'

# Set the environment (development, test, production)
ENV['RACK_ENV'] ||= 'development'

use Rack::Reloader, 0

run ApplicationController.new(ENV['RACK_ENV'])
