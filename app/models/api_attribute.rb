class ApiAttribute < ApplicationRecord
  belongs_to :api_resource

  has_many :api_validations, inverse_of: :api_attribute

  validates_uniqueness_of :name, scope: :api_resource_id

  accepts_nested_attributes_for :api_validations, reject_if: :all_blank, allow_destroy: true

  DB_TYPE_OPTIONS = [
      :string,
      :text,
      :numeric,
      :date,
      :currency,
      :json,
      :password,
      :uuid
  ].freeze

  def as_json(opts={})
    result = self.attributes.symbolize_keys.except(:api_resource_id, :created_at, :updated_at)

    result[:api_validations] = self.api_validations.to_a.map {|api_validation| api_validation.as_json}

    result
  end

  def formatted_name
    name.downcase.gsub(' ', '_')
  end

end
