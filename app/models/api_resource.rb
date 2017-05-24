class ApiResource < ApplicationRecord
  belongs_to :api_project

  has_many :api_attributes, dependent: :destroy, inverse_of: :api_resource
  has_many :api_associations, dependent: :destroy, inverse_of: :api_resource

  validates_uniqueness_of :name, scope: :api_project_id

  accepts_nested_attributes_for :api_attributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :api_associations, reject_if: :all_blank, allow_destroy: true

  def as_json(opts={})
    result = self.attributes.symbolize_keys.except(:api_project_id, :created_at, :updated_at)

    result[:api_attributes] = self.api_attributes.to_a.map{|api_attribute| api_attribute.as_json }
    result[:api_associations] = self.api_associations.to_a.map{|api_association| api_association.as_json }

    result
  end

  def table_name
    name.downcase.gsub(' ', '_').pluralize
  end
end
