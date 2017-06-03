class ApiResource < ApplicationRecord
  belongs_to :api_project

  has_many :api_attributes, dependent: :destroy, inverse_of: :api_resource
  has_many :api_associations, dependent: :destroy, inverse_of: :api_resource

  validates_uniqueness_of :name, scope: :api_project_id
  validates_presence_of :name, :api_project

  accepts_nested_attributes_for :api_attributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :api_associations, reject_if: :all_blank, allow_destroy: true

  before_save :set_last_table_name

  def as_json(opts={})
    result = self.attributes.symbolize_keys.except(:api_project_id, :created_at, :updated_at)

    result[:api_attributes] = self.api_attributes.to_a.map{|api_attribute| api_attribute.as_json }
    result[:api_associations] = self.api_associations.to_a.map{|api_association| api_association.as_json }
    result[:reverse_associations] = self.implicit_belongs_to_associations

    result
  end

  def formatted_name
    name.downcase.gsub(' ', '_')
  end

  def table_name
    formatted_name.pluralize
  end

  def belongs_to_relation_resources
    api_associations.where(kind: 'belongs_to').map { |assoc| ApiResource.find_by(name: assoc.resource_name, api_project: api_project) }.uniq
  end

  def nested_attributes_whitelist
    api_associations.where(kind: 'has_many').map { |assoc| "#{assoc.formatted_resource_label}_attributes: [#{ApiResource.find_by(name: assoc.resource_name, api_project: api_project).attributes_including_fk.join(', ')}]" }
  end

  def attributes_including_fk
    arr = api_attributes.map(&:formatted_name)
    arr += implicit_belongs_to_associations.map { |assoc| "#{assoc[:label]}_id" }
    arr.map { |attr| ":#{attr}" }
  end

  def implicit_belongs_to_associations
    ApiAssociation.where(kind: 'has_many', resource_name: name)
        .select { |assoc| assoc.api_resource.api_project == api_project }
        .map do |assoc|
      {
          label: "#{assoc.formatted_resource_label.singularize}_#{assoc.api_resource.formatted_name}",
          class_name: assoc.api_resource.name,
          table_name: assoc.api_resource.table_name,
          inverse_of_label: assoc.formatted_resource_label,
          optional: !assoc.mandatory
      }
    end
  end

  def set_last_table_name
    self.advanced_options ||= {}
    self.advanced_options['last_table_name'] = name_was.blank? ? table_name : name_was.downcase.gsub(' ', '_').pluralize
  end
end
