class ApiUser < ApplicationRecord

  has_one :session, dependent: :destroy
  has_many :api_projects, foreign_key: 'created_by_id', dependent: :destroy
  has_many :api_resources, through: :api_projects

  before_save {self.email = email.downcase}

  before_destroy { self.session.destroy! if self.session.present? }

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

end
