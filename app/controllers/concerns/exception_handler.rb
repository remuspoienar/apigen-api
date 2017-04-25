module ExceptionHandler
  extend ActiveSupport::Concern

  class MissingToken < StandardError
    def initialize(msg = Message.missing_token)
      super(msg)
    end
  end

  class InvalidToken < StandardError
    def initialize(msg = Message.invalid_token)
      super(msg)
    end
  end

  class InvalidCredentials < StandardError
    def initialize(msg = Message.invalid_credentials)
      super(msg)
    end
  end

  included do
    # rescue from record errors
    rescue_from ActiveRecord::RecordNotFound, with: :response_for_404
    rescue_from ActiveRecord::RecordInvalid, with: :response_for_422

    # rescue from auth errors
    rescue_from ExceptionHandler::InvalidCredentials, with: :response_for_400

    # rescue from authorization errors
    rescue_from ExceptionHandler::MissingToken, with: :response_for_422
    rescue_from ExceptionHandler::InvalidToken, with: :response_for_422
  end

  private

  # JSON response with message; Status code 404 - not found
  # JSON response with message; Status code 422 - unprocessable entity
  # JSON response with message; Status code 401 - unauthorized
  # JSON response with message; Status code 400 - bad request

  def response_for(status, exception)
    render json: {
        errors: [exception.message],
    }, status: status
  end

  def response_for_404(e)
    response_for(:not_found, e)
  end

  def response_for_422(e)
    response_for(:unprocessable_entity, e)
  end

  def response_for_401(e)
    response_for(:unauthorized, e)
  end

  def response_for_400(e)
    response_for(:bad_request, e)
  end
end