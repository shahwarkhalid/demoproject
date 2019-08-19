# frozen_string_literal: true

class User::ProjectsController < ProjectsController
  def index
    authorize User, :check_user?, policy_class: UserPolicy
    @projects = Project.search_employee_projects(params, current_user).page(params[:page])
  end

  def show
    super
    authorize User, :check_user?, policy_class: UserPolicy
    @timelogs = @timelogs.where(creator_id: current_user.id)
  end
end
