class ApiUser < ApplicationRecord

  has_many :api_projects, foreign_key: 'created_by_id', dependent: :destroy

  before_save {self.email = email.downcase}

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  def as_json(opts={})
    self.attributes.symbolize_keys.except(:created_at, :updated_at, :password_digest)
  end

  def authorized?(action, resource_table_name, api_project)
    api_resource = api_project.api_resources.to_a.select {|api_resource| api_resource.table_name == resource_table_name }.first
    permission = api_resource ? Permission.find_by(api_resource: api_resource, api_user: self) : nil
    permission ? permission.actions.include?(action) : false
  end

end
