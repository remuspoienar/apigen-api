class AddApiHostToApiProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :api_projects, :api_host, :string

    ApiProject.all.each { |api_project| api_project.allocate_host }
  end
end
