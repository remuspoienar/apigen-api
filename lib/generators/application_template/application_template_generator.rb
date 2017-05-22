class ApplicationTemplateGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_application_template_file
    file_content = File.open(File.expand_path('../templates/application_template.rb', __FILE__)).read
    create_file "#{destination_root}/application_templates/#{api_project.formatted_name}_template.rb", eval(file_content)
  end

  private

  def args_hash
    @args_hash ||= Hash[args.map{|arg| [arg.split('=')[0], arg.split('=')[1]]}]
  end

  def api_project
    @api_project ||= ApiProject.find(args_hash['api_project'])
  end
end
