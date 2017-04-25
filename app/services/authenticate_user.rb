class AuthenticateUser

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    raise ExceptionHandler::InvalidCredentials if email.blank? || password.blank?
    authenticate_user
  end

  private

  attr_reader :email, :password

  def authenticate_user
    user = ApiUser.find_by!(email: email)

    if user.authenticate(password)
      token = JsonWebToken.encode(user_id: user.id)
      Session.create!(token: token, api_user: user)
      return token
    end

    raise ExceptionHandler::InvalidCredentials
  end
end