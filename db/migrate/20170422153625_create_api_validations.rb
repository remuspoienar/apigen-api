class CreateApiValidations < ActiveRecord::Migration[5.0]
  def change
    create_table :api_validations do |t|
      t.references :api_attribute, foreign_key: true
      t.string :trait
      t.text :advanced_options

      t.timestamps
    end
  end
end
