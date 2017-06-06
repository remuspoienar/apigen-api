class AddAdvancedOptionsToApiProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :api_projects, :advanced_options, :json

    ApiProject.find_each { |api_project| api_project.update_attribute(:advanced_options, {generator_app_url: 'http://localhost:3003'})}
  end
end
