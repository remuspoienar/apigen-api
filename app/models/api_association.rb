class ApiAssociation < ApplicationRecord
  belongs_to :api_resource

  validates_uniqueness_of :resource_label, scope: [:kind, :api_resource_id]

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_resource_id, :created_at, :updated_at)
  end
end
