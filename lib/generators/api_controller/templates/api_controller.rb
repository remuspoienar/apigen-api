<<-CODE
class #{controller_class_name}Controller < ApplicationController
  before_action :set_#{file_name}, only: [:show, :update, :destroy]

  # GET /#{plural_file_name}
  def index
    chunk = pagination_params[:limit].blank? ? #{class_name}.all : #{class_name}.limit(pagination_params[:limit])
    count = chunk.count
    @#{plural_file_name} = Kaminari.paginate_array(chunk.order("\#{sort_column} \#{sort_direction.upcase}"))
    @#{plural_file_name} = @#{plural_file_name}.page(pagination_params[:page]) unless pagination_params[:page].blank?
    @#{plural_file_name} = @#{plural_file_name}.per(pagination_params[:per]) unless pagination_params[:per].blank?
    @#{plural_file_name} = @#{plural_file_name}.map(&:attributes).map{ |x| x.slice(*params[:includes].split(','))} unless params[:includes].blank?
    render json: {rows: @#{plural_file_name}, page: {count: count}}, status: :ok
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

  def pagination_params
    params.permit(:limit, :per, :page, :includes)
  end

  def sort_params
    params.permit(:sort_column, :sort_direction)
  end

  def sort_direction
    params[:sort_direction].in?(%w{asc desc}) ? params[:sort_direction] : 'asc'
  end

  def sort_column
    #{class_name}.column_names.include?(params[:sort_column]) ? params[:sort_column] : 'id'
  end
end
CODE