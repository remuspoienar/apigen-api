class ApiAssociation < ApplicationRecord
  belongs_to :api_resource

  validates_uniqueness_of :resource_label, scope: [:kind, :api_resource_id]

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_resource_id, :created_at, :updated_at)
  end

  def as_code
    result = ''
    result << "\t#{kind} :#{formatted_resource_label}, class_name: '#{resource_name}', inverse_of: :#{api_resource.name.underscore}\n"
    result << "\taccepts_nested_attributes_for :#{formatted_resource_label}, reject_if: :all_blank, allow_destroy: true\n"
    result << "\n"
    result
  end

  def formatted_resource_label
    result = resource_label.underscore.gsub(' ', '_')
    result.singularize
    result = result.pluralize if kind == 'has_many'
    result
  end

  def belongs_to?
    kind == 'belongs_to'
  end
end
