class AddLaunchedToApiProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :api_projects, :launched, :boolean, default: false

    ApiProject.all.each { |api_project| api_project.update_attribute(:launched, false) }
  end
end
