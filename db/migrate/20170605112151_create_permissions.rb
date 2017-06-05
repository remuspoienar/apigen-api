class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.references :api_user, foreign_key: true
      t.references :api_resource, foreign_key: true
      t.text :actions

      t.timestamps
    end

    ApiResource.find_each { |api_resource| Permission.create_for_admin(api_resource) }
  end
end
