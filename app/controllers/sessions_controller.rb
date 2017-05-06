class SessionsController < ApplicationController

  skip_before_action :authorize_request!, only: :create

  def create
    token = auth_service.call

    render json: {token: token}, status: :ok
  end

  def destroy
    render json: {message: Message.user_signed_out}, status: :ok
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def auth_service
    @auth_service ||= AuthenticateUser.new(session_params[:email], session_params[:password])
  end
end