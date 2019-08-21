# frozen_string_literal: true

class Api::V1::ProjectsController < ApiController
  before_action :set_project, only: %i[show update destroy]
  before_action :set_project_for_employees, only: %i[create_employees_list get_employees_list]
  before_action :authorise_user, only: %i[create update destroy get_employees_list create_employees_list]
  before_action :authorise_user_for_project, only: %i[show update destroy], if: :user?
  before_action :authorize_request

  def index
    render json: Project.search_projects(params, current_user)
  end

  def create
    @project = Project.new(project_params)
    @project.creator = current_user
    @project.manager = current_user if current_user.manager?
    @project.status = 1
    @project.save
    render json: @project.errors.any? ? @project.errors : @project
  end

  def show
    render json: @project
  end

  def update
    @project.update(project_params)
    render json: @project.errors.any? ? @project.errors : @project
  end

  def destroy
    @project.destroy
    render json: 'project was deleted'
  end

  def get_employees_list
    render json: @project.employees.order(:id)
  end

  def create_employees_list
    Project.add_employees_by_emails_api(@project, params)
    render json: 'Employees assigned successfully'
  end

  private

  def set_project
    @project = Project.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @project
  end

  def set_project_for_employees
    @project = Project.find_by_id(params[:project_id])
    render json: 'record not found', status: :not_found unless @project
  end

  def authorise_user
    render json: 'you are not authorised to access' if current_user.user?
  end

  def authorise_user_for_project
    render json: 'you are not authorised to access' unless Project.valid_project?(@project, current_user)
  end

  def project_params
    params.permit(:title, :description, :total_hours, :manager_id, :client_id)
  end

  def user?
    current_user.user? || current_user.manager?
  end
end
