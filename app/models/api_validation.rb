class ApiValidation < ApplicationRecord
  belongs_to :api_attribute

  validates_uniqueness_of :trait, scope: :api_attribute_id

  TRAIT_OPTIONS = {
      length: [:min, :max],
      format: [:regexp],
      presence: [],
      inclusion: [:array],
      exclusion: [:array],
      uniqueness: [],
      numericality: []
  }.freeze

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_attribute_id, :created_at, :updated_at)
  end
end
