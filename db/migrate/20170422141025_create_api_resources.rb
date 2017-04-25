class CreateApiResources < ActiveRecord::Migration[5.0]
  def change
    create_table :api_resources do |t|
      t.string :name
      t.references :api_project, foreign_key: true

      t.timestamps
    end
  end
end
