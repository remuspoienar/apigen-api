<<-CODE
class #{controller_class_name}Controller < ApplicationController
  before_action :set_#{file_name}, only: [:show, :update, :destroy]
  before_action :authorize_request

  # GET /#{plural_file_name}
  def index
    q = filter_params.blank? ? #{class_name} : #{class_name}.ransack(filter_params).result
    @#{plural_file_name} = q.order("\#{sort_column} \#{sort_direction.upcase}")
    @#{plural_file_name} = @#{plural_file_name}.limit(pagination_params[:limit]) unless pagination_params[:limit].blank?
    count = @#{plural_file_name}.count
    @#{plural_file_name} = @#{plural_file_name}.select(*includes_params) unless includes_params.blank?
    @#{plural_file_name} = Kaminari.paginate_array(@#{plural_file_name}).page(pagination_params[:page]) unless pagination_params[:page].blank?
    @#{plural_file_name} = @#{plural_file_name}.per(pagination_params[:per]) unless pagination_params[:per].blank?

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

  def bulk_delete
    #{class_name}.where(id:  bulk_ids).destroy_all
  end

  private

  def set_#{file_name}
    @#{file_name} = #{class_name}.find(params[:id])
  end

  # whitelist parameters
  def #{file_name}_params
    params.require(:#{file_name}).permit(#{permitted_attributes_list})
  end

  def bulk_ids
    params.permit(ids: [])[:ids]
  end

  def filter_params
    params[:q].blank? ? nil : params.require(:q).permit!
  end

  def includes_params
    params.permit(includes: []).blank? ? nil : params.permit(includes: [])[:includes].select{|attr| #{class_name}.column_names.include?(attr) }
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