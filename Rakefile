require 'rake'
require 'active_record'
require 'yaml'

# Load database configuration
db_config = YAML.load_file('config/database.yml')
ActiveRecord::Base.configurations = db_config

# Establish connection to a temporary database to create the actual database
def establish_temp_connection(config)
  ActiveRecord::Base.establish_connection(config.merge('database' => nil))
end

namespace :db do
  desc "Create the database"
  task :create do
    config = ActiveRecord::Base.configurations.configs_for(env_name: :development).first.configuration_hash
    establish_temp_connection(config)
    ActiveRecord::Base.connection.create_database(config['database'], config)
    ActiveRecord::Base.establish_connection(config)
  end

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Base.establish_connection(:development)
    migration_context = ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration)
    migration_context.migrate
  end

  desc "Create a new migration"
  task :create_migration, [:name] do |t, args|
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    migration_name = "#{timestamp}_#{args[:name]}.rb"
    migration_dir = "db/migrate"
    migration_file_path = File.join(migration_dir, migration_name)
    class_name = args[:name].split('_').map(&:capitalize).join
    File.open(migration_file_path, 'w') do |file|
      file.write <<-MIGRATION
class #{class_name} < ActiveRecord::Migration[6.1]
  def change
    # Define your table here
  end
end
      MIGRATION
    end
    puts "Created migration file: #{migration_file_path}"
  end
end
