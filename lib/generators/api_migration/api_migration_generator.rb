class ApiMigrationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_migration_file
    file_content = File.open(File.expand_path('../templates/api_migration.rb', __FILE__)).read
    create_file "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_resources.rb", eval(file_content)
  end

  private

  def args_hash
    @args_hash ||= Hash[args.map{|arg| [arg.split('=')[0], arg.split('=')[1]]}]
  end

  def api_project
    @api_project ||= ApiProject.find(args_hash['api_project'])
  end

  def associated_table_name(association)
    ApiResource.find_by(name: association.resource_name,api_project: api_project).table_name
  end

end
