<<-CODE
class CreateResources < ActiveRecord::Migration[5.0]
  def change
#{
str = ''
ref_str = ''
api_project.api_resources.each do |resource|
  str << "\t\tcreate_table :#{resource.table_name} do |t|\n"
  
  resource.api_attributes.each do |attribute|
    str << "\t\t\tt.#{attribute.db_type} :#{attribute.name}\n"
  end
  
  str << "\t\t\tt.timestamps\n"
  
  # resource.api_associations.select{|a| a.belongs_to? }.each do |association|
  #   ref_str << "\t\t add_reference :#{resource.table_name}, :#{association.formatted_resource_label}, foreign_key: {to_table: :#{associated_table_name(association)}}\n"
  # end
  # 
  
  # resource.has_many_relation_labels.each do |resource_name|
  #   ref_str << "\t\t add_reference :#{resource.table_name}, :#{resource_name}, foreign_key: true\n"
  # end

  resource.implicit_belongs_to_associations.each do |assoc|
    ref_str << "\t\tadd_reference :#{resource.table_name}, :#{assoc[:label]}, foreign_key: {to_table: :#{assoc[:table_name]}}\n"
  end
  
  str << "\t\tend\n\n"
end
str + ref_str
}
  end
end

CODE