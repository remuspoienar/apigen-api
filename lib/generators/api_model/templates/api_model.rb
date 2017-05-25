<<-CODE
#{api_resource = ApiResource.find_by(name: class_name, api_project: api_project); nil}class #{api_resource.name} < ApplicationRecord

  # associations
#{
associations = ''
api_resource.api_associations.each do |assoc|
  associations << assoc.as_code
end

api_resource.implicit_belongs_to_associations.each do |assoc|
  associations << "\tbelongs_to :#{assoc[:label]}, class_name: '#{assoc[:class_name]}', foreign_key: '#{assoc[:label]}_id',  inverse_of: :#{assoc[:inverse_of_label]}\n"
end

associations
}

  # validations
#{
validations = ''
api_resource.api_attributes.each do |attribute|
  next if attribute.api_validations.blank?
  validations << "\tvalidates :#{attribute.name},\n"
  trait_options = []
  attribute.api_validations.each do |validation|
    trait_options << validation.as_code
  end
  validations << trait_options.join(", \n")
  validations << "\n"
end

validations
}

# other

end
CODE
