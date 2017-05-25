class ApiAssociation < ApplicationRecord
  belongs_to :api_resource

  validates_uniqueness_of :resource_label, scope: [:kind, :api_resource_id]

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_resource_id, :created_at, :updated_at)
  end

  def as_code
    result = ''
    result << "\t#{kind} :#{formatted_resource_label}, class_name: '#{resource_name}'"
    if has_many?
      fk = "#{formatted_resource_label.singularize}_#{api_resource.formatted_name}"
      result << ", inverse_of: :#{fk}, foreign_key: '#{fk}_id', dependent: :destroy\n"
      result << "\taccepts_nested_attributes_for :#{formatted_resource_label}, reject_if: :all_blank, allow_destroy: true\n" if has_many?
    end
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

  def has_many?
    kind == 'has_many'
  end
end
