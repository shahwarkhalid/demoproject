# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :validate_admin!

  def index
    @top_projects = Project.top_projects
    @bottom_projects = Project.bottom_projects
  end

  protected

  def validate_admin!
    redirect_to root_url unless current_user.admin?
  end
end
