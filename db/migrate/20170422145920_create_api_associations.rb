class CreateApiAssociations < ActiveRecord::Migration[5.0]
  def change
    create_table :api_associations do |t|
      t.string :resource_name
      t.string :resource_label
      t.string :kind
      t.references :api_resource, foreign_key: true
      t.text :advanced_options

      t.timestamps
    end
  end
end
