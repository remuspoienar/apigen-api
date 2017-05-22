<<-CODE
#{api_resource = ApiResource.find_by(name: class_name, api_project: api_project); nil}class #{api_resource.name} < ApplicationRecord

  # associations
#{
associations = ''
api_resource.api_associations.each do |assoc|
  associations << assoc.as_code
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
