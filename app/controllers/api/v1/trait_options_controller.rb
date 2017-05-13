class Api::V1::TraitOptionsController < ApplicationController

  def index
    render json: {result: ApiValidation::TRAIT_OPTIONS}, status: :ok
  end
end