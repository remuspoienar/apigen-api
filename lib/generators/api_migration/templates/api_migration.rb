<<-CODE
class CreateResources < ActiveRecord::Migration[5.0]
  def change
#{
str = ''
api_project.api_resources.each do |resource|
  str << "\t\tcreate_table :#{resource.table_name} do |t|\n"
  
  resource.api_attributes.each do |attribute|
    str << "\t\t\tt.#{attribute.db_type} :#{attribute.name}\n"
  end
  
  str << "\t\t\tt.timestamps\n"
  str << "\t\t\t#from associations\n"
  
  resource.api_associations.select{|a| a.belongs_to? }.each do |association|
    str << "\t\t\tt.references :#{association.formatted_resource_label}, foreign_key: {to_table: :#{associated_table_name(association)}}"
  end
  
  str << "\t\tend\n\n"
end
str
}
  end
end

CODE