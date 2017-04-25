class CreateApiAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :api_attributes do |t|
      t.references :api_resource, foreign_key: true
      t.string :name
      t.string :db_type

      t.timestamps
    end
  end
end
