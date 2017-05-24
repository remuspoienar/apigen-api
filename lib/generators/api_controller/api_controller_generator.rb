class ApiControllerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)

  def create_controller_file
    file_content = File.open(File.expand_path('../templates/api_controller.rb', __FILE__)).read
    create_file "app/controllers/#{plural_file_name}_controller.rb", eval(file_content)
  end

  private

  def args_hash
    @args_hash ||= Hash[args.map { |arg| [arg.split('=')[0], arg.split('=')[1]] }]
  end

  def api_project
    @api_project ||= ApiProject.find(args_hash['api_project'])
  end

  def permitted_attributes_list
    @permitted_attributes_list ||= ApiResource.find_by(name: class_name, api_project: api_project).api_attributes.map(&:name).map { |name| ":#{name}" }.join(', ')
  end
end
