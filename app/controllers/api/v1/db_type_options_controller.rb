class Api::V1::DbTypeOptionsController < ApplicationController

  def index
    render json: {result: ApiAttribute::DB_TYPE_OPTIONS}, status: :ok
  end
end