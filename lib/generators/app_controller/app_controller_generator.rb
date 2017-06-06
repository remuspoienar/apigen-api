class AppControllerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers

  source_root File.expand_path('../templates', __FILE__)

  def create_app_controller_file
    file_content = File.open(File.expand_path('../templates/app_controller.rb', __FILE__)).read
    create_file 'app/controllers/application_controller.rb', eval(file_content)
  end
end
