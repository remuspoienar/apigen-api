<<-CODE
class #{controller_class_name}Controller < ApplicationController
  before_action :set_#{file_name}, only: [:show, :update, :destroy]

  # GET /#{plural_file_name}
  def index
    @#{plural_file_name} = #{class_name}.all
    render json: @#{plural_file_name}
  end

  # GET /#{plural_file_name}/1
  def show
    render json: @#{file_name}
  end

  # POST /#{plural_file_name}
  def create
    @#{file_name} = #{class_name}.new(#{file_name}_params)
    
    if @#{file_name}.save
      render json: @#{file_name}, status: :created, location: @#{file_name}
    else
      render json: @#{file_name}.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /#{plural_file_name}/1
  def update
    if @#{file_name}.update(#{file_name}_params)
      render json: @#{file_name}
    else
      render json: @#{file_name}.errors, status: :unprocessable_entity
    end
  end

  # DELETE /#{plural_file_name}/1
  def destroy
    @#{file_name}.destroy
  end

  private

  def set_#{file_name}
    @#{file_name} = #{class_name}.find(params[:id])
  end

  # whitelist parameters
  def #{file_name}_params
    params.require(:#{file_name}).permit(#{permitted_attributes_list})
  end
end
CODE