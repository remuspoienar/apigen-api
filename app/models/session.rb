class Session < ApplicationRecord
  belongs_to :api_user

  def valid_for_user?(user_id)
    self.created_at == self.updated_at && self.api_user_id == user_id
  end
end
