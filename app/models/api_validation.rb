class ApiValidation < ApplicationRecord
  belongs_to :api_attribute

  validates_uniqueness_of :trait, scope: :api_attribute_id
  validates_presence_of :trait, :api_attribute

  TRAIT_OPTIONS = {
      length: [:min, :max],
      format: [:regexp],
      presence: [],
      inclusion: [:list],
      exclusion: [:list],
      uniqueness: [],
      numericality: []
  }.freeze

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_attribute_id, :created_at, :updated_at)
  end

  def as_code
    result = "\t" * 6
    result << "#{trait}: #{formatted_advanced_options}"
    result
  end

  private

  def formatted_advanced_options
    return 'true' if advanced_options.blank?

    formatted_hash(advanced_options)
  end

  def formatted_hash(hash)
    result = []
    hash.each do |key, val|
      result << "#{key_correction(key)}: #{value_correction(val)}"
    end
    "{#{result.join(', ')}}"
  end

  def key_correction(key)
    return KEY_MAP[key.to_sym].to_s if KEY_MAP.key?(key.to_sym)
    key.to_s
  end

  def value_correction(value)
    value = value.to_s
    if value.match(/^[\d]+$/)
      value = value.to_i
    elsif value.match(/^[.\d]+$/)
      value = value.to_f
    end
    "'#{value}'" if value.is_a? String
    value
  end

  KEY_MAP = {
      max: :maximum,
      min: :minimum,
      regexp: :with,
      list: :in
  }.freeze
end
