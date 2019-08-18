# frozen_string_literal: true

class ManagerController < ApplicationController
  before_action :validate_manager!

  def index
    @top_projects = Project.manager_top_projects(current_user)
  end

  protected

  def validate_manager!
    redirect_to root_url unless current_user.manager?
  end
end
