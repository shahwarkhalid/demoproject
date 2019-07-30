class AdminController < ApplicationController
  before_action :check_admin_validation

  def index
  end

  protected

  def check_admin_validation
    authorize User, :check_admin? , policy_class: UsersPolicy
  end
end
