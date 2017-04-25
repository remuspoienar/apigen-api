class CreateApiProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :api_projects do |t|
      t.string :name
      t.references :created_by, foreign_key: {to_table: :api_users}

      t.timestamps
    end
  end
end
