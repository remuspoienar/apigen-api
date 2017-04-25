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
    @user = session.api_user if token_payload && session.valid_for_user?(token_payload[:user_id])
  rescue ActiveRecord::RecordNotFound
    raise ExceptionHandler::InvalidToken
  end

  def token_payload
    @token_payload ||= JsonWebToken.decode(session.token)
  end

  def session
    @session ||= Session.find_by!(token: token)
  end

  def token
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    end
    raise ExceptionHandler::MissingToken
  end
end