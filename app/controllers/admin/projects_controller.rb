# frozen_string_literal: true

class Admin::ProjectsController < ProjectsController
  before_action :authorize_user

  def index
    @projects = Project.search_projects(params, current_user).page(params[:page])
  end

  def show; end

  def new
    super
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    @project.creator = current_user
    @project.status = 1
    @project.save
  end


  def update
    @project.update(project_params)
  end

  def destroy
    @project.destroy
  end

  def assign_employees
  end

  def create_employees_list
    super
  end

  def employee_list
    super
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :total_hours, :manager_id, :client_id)
  end

  def authorize_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end
end
