class Api::V1::ApiProjectsController < ApplicationController

  before_action :set_api_project, only: [:show, :update, :destroy, :launch, :shutdown, :permissions]

  def index
    render json: current_user.api_projects, status: :ok
  end

  def show
    render json: current_user.api_projects.find(params[:id]), status: :ok
  end

  def create
    api_project = current_user.api_projects.create!(create_api_project_params)
    api_project.generate_code
    render json: {}, status: :created
  end

  def update
    api_project = current_user.api_projects.find(params[:id])
    api_project.update!(update_api_project_params)
    api_project.generate_code
    render json: {}, status: :ok
  end

  def destroy
    current_user.api_projects.find(params[:id]).destroy
    render json: {}, status: :ok
  end

  def launch
    current_user.api_projects.find(params[:id]).launch
    render json: {message: "ApiProject ##{params[:id]} launched successfully"}, stauts: :ok
  end

  def shutdown
    current_user.api_projects.find(params[:id]).shutdown
    render json: {message: "ApiProject ##{params[:id]} shut down successfully"}, stauts: :ok
  end

  def permissions
    render json: @api_project.api_resources.map(&:permissions), status: :ok
  end

  private

  def set_api_project
    @api_project ||= ApiProject.find(params[:id])
  end

  def create_api_project_params
    params.permit(
        :name,
        api_resources_attributes: [
            :name,
            api_attributes_attributes: [
                :name,
                :db_type,
                api_validations_attributes: [
                    :trait,
                    {advanced_options: [:min, :max, :regexp, :list]}
                ]
            ],
            api_associations_attributes: [
                :resource_name,
                :resource_label,
                :kind,
                :mandatory,
                advanced_options: []
            ],
            permissions_attributes: [
                {actions: []},
                :api_user_id
            ]
        ],
    )
  end

  def update_api_project_params
    params.permit(
        :name,
        api_resources_attributes: [
            :id,
            :_destroy,
            :name,
            api_attributes_attributes: [
                :id,
                :_destroy,
                :name,
                :db_type,
                api_validations_attributes: [
                    :id,
                    :_destroy,
                    :trait,
                    {advanced_options: [:min, :max, :regexp, :list]}
                ]
            ],
            api_associations_attributes: [
                :id,
                :_destroy,
                :resource_name,
                :resource_label,
                :kind,
                :mandatory,
                {advanced_options: []}
            ],
            permissions_attributes: [
                :id,
                :api_user_id,
                {actions: []},
                :_destroy
            ]
        ],
    )
  end
end

#sample json body for create request
# {"api_project": {"name": "sample name 3", "api_resources_attributes": [{"name": "Message", "api_attributes_attributes": [{"name": "content", "db_type": "text"}]}, {"name": "Enterprise", "api_attributes_attributes": [{"name": "alert_key", "db_type": "string", "api_validations_attributes": [{"trait": "length", "advanced_options": "{\"min\": \"32\", \"max\":\"50\"}"}]}]}]}}
