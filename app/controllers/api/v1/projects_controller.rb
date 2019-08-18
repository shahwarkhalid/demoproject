# frozen_string_literal: true

class Api::V1::ProjectsController < ApiController
  before_action :set_project, only: %i[show update destroy]

  def index
    projects = Project.all
    render json: projects
  end

  def create
    @project = Project.new(project_params)
    @project.creator_id = 10
    @project.status = 1
    byebug
    @project.save
    render json: @project
  end

  def show
    render json: @project
  end

  def update
    @project.update(project_params)
    render json: @project
  end

  def destroy
    @project.destroy
    render json: 'project was deleted'
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @project
  end

  def project_params
    params.permit(:title, :description, :total_hours, :manager_id, :client_id)
  end
end
