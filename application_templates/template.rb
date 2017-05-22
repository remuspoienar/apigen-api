require_relative "./apigen/lib/generators/api_model/api_model_generator.rb"
require 'active_record'
require 'yaml'

db_config = YAML.load_file('../apigen/config/database.yml')
db_config['development']['pool'] = 5
ActiveRecord::Base.establish_connection(db_config['development'])

models_path = File.join(Dir.pwd, '..', 'apigen', 'app', 'models')

require_relative models_path + '/application_record.rb'
models = Dir.entries(models_path)
models.select {|file_name| !!(file_name =~ /\A*.rb\z/) }.each { |file_name| require_relative models_path + "/#{file_name}" }

invoke(:api_model, ["Enterprise", "api_project=5"])
route "root to: 'people#index'"
rails_command("db:setup")
rails_command("db:migrate")
 
#after_bundle do
 # git :init
  #git add: "."
  #git commit: %Q{ -m 'Initial commit' }
#end

