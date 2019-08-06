# frozen_string_literal: true

class User::ProjectsController < ProjectsController
  def index
    authorize User, :check_user?, policy_class: UserPolicy
    @projects = current_user.projects.order(:created_at).page(params[:page])
  end

  def show
    super
    authorize User, :check_user?, policy_class: UserPolicy
    @timelogs = @timelogs.where(creator_id: current_user.id)
  end
end
