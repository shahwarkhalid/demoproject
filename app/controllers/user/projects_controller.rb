# frozen_string_literal: true

class User::ProjectsController < ProjectsController
  before_action :authorise_user

  def index
    @projects = Project.search_projects(params, current_user).page(params[:page])
  end

  def show
    super
    @timelogs = @timelogs.where(creator_id: current_user.id)
  end

  def authorise_user
    authorize User, :check_user?, policy_class: UserPolicy
  end
end
