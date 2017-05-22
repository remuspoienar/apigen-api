class ApiModelGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)

  def create_api_model_file
    file_content = File.open(File.expand_path('../templates/api_model.rb', __FILE__)).read
    create_file "app/models/#{file_name}.rb", eval(file_content)
    # create_file "api_projects/#{api_project.formatted_name}/app/models/#{file_name}.rb", eval(file_content)
  end

  private

  def args_hash
    @args_hash ||= Hash[args.map{|arg| [arg.split('=')[0], arg.split('=')[1]]}]
  end

  def api_project
    @api_project ||= ApiProject.find(args_hash['api_project'])
  end

end
