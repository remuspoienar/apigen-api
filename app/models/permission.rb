class Permission < ApplicationRecord
  belongs_to :api_user
  belongs_to :api_resource

  serialize :actions

  validates :actions, presence: true

  validates_uniqueness_of :api_user, scope: :api_resource_id

  before_validation :set_default_actions, if: Proc.new { |permission| permission.actions.blank? }

  def self.create_for_admin(api_resource)
    instance = self.new(api_resource_id: api_resource.id, api_user_id: api_resource.api_project.created_by_id)
    instance.actions = %w{ index create show update destroy }
    instance.save!
  end

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:api_resource_id, :created_at, :updated_at)
  end

  private

  def set_default_actions
    self.actions = %w{ index show }
  end
end
