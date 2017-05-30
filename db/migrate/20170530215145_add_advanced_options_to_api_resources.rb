class AddAdvancedOptionsToApiResources < ActiveRecord::Migration[5.0]
  def change
    add_column :api_resources, :advanced_options, :json

    ApiResource.find_each { |api_resource| api_resource.update_attribute(:advanced_options, {last_table_name: api_resource.table_name}) }
  end
end
