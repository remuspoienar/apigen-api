<<-CODE
require_relative './apigen-api/lib/generators/api_model/api_model_generator.rb'
require_relative './apigen-api/lib/generators/api_migration/api_migration_generator.rb'
require_relative './apigen-api/lib/generators/api_controller/api_controller_generator.rb'
require_relative './apigen-api/lib/generators/backup_task/backup_task_generator.rb'

require 'active_record'
require 'yaml'

gem 'rack-cors'
gem 'bcrypt'
gem 'ransack'

db_config = YAML.load_file('../apigen-api/config/database.yml')
db_config['development']['pool'] = 5
ActiveRecord::Base.establish_connection(db_config['development'])

models_path = File.join(Dir.pwd, '..', 'apigen-api', 'app', 'models')

require_relative models_path + '/application_record.rb'
models = Dir.entries(models_path)
models.select { |file_name| !!(file_name =~ /\\A*.rb\\z/) }.each { |file_name| require_relative models_path + "/\#{file_name}" }

#{
str = ''
api_project.api_resources.each do |resource|
  str << "Rails::Generators.invoke(:api_model, ['#{resource.name}', 'api_project=#{api_project.id}'])\n"
  str << "Rails::Generators.invoke(:api_controller, ['#{resource.name}', 'api_project=#{api_project.id}'])\n"
  str << "route 'resources :#{resource.table_name}, concerns: :bulk_deletable'\n"
  str << "\n"
end
str
}
Rails::Generators.invoke(:api_migration, ['App', 'api_project=#{api_project.id}'])
Rails::Generators.invoke(:backup_task, ['Backup Task', 'api_project=#{api_project.id}'])

# bulk delete routing
route <<-ROUTE
concern :bulk_deletable do
    delete :index, on: :collection, action: :bulk_delete
  end
ROUTE


application <<-CONFIG
config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
      end
    end
CONFIG

#{'rake "backup:store" # save data' if api_project.created_at < api_project.updated_at}

rails_command("db:migrate:reset")

#{'rake "backup:load" # restore data' if api_project.created_at < api_project.updated_at}

after_bundle do
  run("bin/spring stop")
  # git :init
  # git add: "."
  # git commit: %Q{ -m 'Initial commit' }
end

CODE