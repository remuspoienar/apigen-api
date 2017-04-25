class Api::V1::ApiProjectsController < ApplicationController

  def index
    render json: current_user.api_projects, status: :ok
  end

  def show
    render json: current_user.api_projects.find(params[:id]), status: :ok
  end

  def create
    current_user.api_projects.create!(create_api_project_params)
    render json: {}, status: :created
  end

  def update
    current_user.api_projects.find(params[:id]).update!(update_api_project_params)
    render json: {}, status: :ok
  end

  def destroy
  end

  private

  def create_api_project_params
    params.require(:api_project).permit(
        :name,
        api_resources_attributes: [
            :name,
            api_attributes_attributes: [
                :name,
                :db_type,
                api_validations_attributes: [
                    :trait,
                    :advanced_options
                ]
            ],
            api_associations_attributes: [
                :resource_name,
                :resource_label,
                :kind,
                :advanced_options
            ]
        ],
    )
  end

  def update_api_project_params
    params.permit(
        :id,
        :name,
        api_resources_attributes: [
            :id,
            :name,
            api_attributes_attributes: [
                :id,
                :name,
                :db_type,
                api_validations_attributes: [
                    :id,
                    :trait,
                    :advanced_options
                ]
            ],
            api_associations_attributes: [
                :id,
                :resource_name,
                :resource_label,
                :kind,
                :advanced_options
            ]
        ],
    )
  end
end

#sample json body for create request
# {"api_project": {"name": "sample name 3", "api_resources_attributes": [{"name": "Message", "api_attributes_attributes": [{"name": "content", "db_type": "text"}]}, {"name": "Enterprise", "api_attributes_attributes": [{"name": "alert_key", "db_type": "string", "api_validations_attributes": [{"trait": "length", "advanced_options": "{\"min\": \"32\", \"max\":\"50\"}"}]}]}]}}
