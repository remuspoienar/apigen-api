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
    return @permitted_attributes_list unless @permitted_attributes_list.blank?

    resource = ApiResource.find_by(name: class_name, api_project: api_project)
    permitted_attributes = resource.api_attributes.map(&:formatted_name)
    permitted_attributes += resource.implicit_belongs_to_associations.map { |assoc| "#{assoc[:label]}_id" }
    @permitted_attributes_list = permitted_attributes.map { |name| ":#{name}" }.join(', ')
    @permitted_attributes_list << ', ' + resource.nested_attributes_whitelist.join(', ') unless resource.nested_attributes_whitelist.blank?
    @permitted_attributes_list
  end
end
