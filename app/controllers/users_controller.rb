class UsersController < ApplicationController

  skip_before_action :authorize_request!, only: :create

  def create
    user = ApiUser.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, token: auth_token }
    render json: response, status: :created
  end

  def me
    render json: current_user.attributes, status: :ok
  end

  def update
    current_user.update!(user_params)
  end

  def destroy
    current_user.destroy!
  end

  private

  def user_params
    params.permit(
        :name,
        :email,
        :password,
        :password_confirmation
    )
  end
end
