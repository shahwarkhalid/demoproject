# frozen_string_literal: true

class User::ProjectsController < ProjectsController
  def index
    @projects = current_user.projects.order(:created_at).page(params[:page])
  end
end
