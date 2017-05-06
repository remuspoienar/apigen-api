class AuthorizeRequest

  def initialize(headers)
    @headers = headers
  end

  def call
    authorize_request
    {
        user: @user
    }
  end

  private

  attr_reader :headers

  def authorize_request
    @user = ApiUser.find(token_payload[:user_id]) if token_payload
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken
  end

  def token_payload
    @token_payload ||= JsonWebToken.decode(token)
  end

  def token
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise ExceptionHandler::MissingToken
  end
end