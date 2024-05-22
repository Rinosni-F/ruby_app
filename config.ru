require 'rack'
require_relative 'app/controllers/application_controller'
# Database configuration
DB_CONFIG = {
    host: 'localhost',
    username: 'root',
    password: 'rino',
    database: 'indexing',
    port: 3306 # Default MySQL 
}


use Rack::Reloader, 0

run ApplicationController.new(DB_CONFIG)

