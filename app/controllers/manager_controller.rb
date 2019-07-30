class ManagerController < ApplicationController
  before_action :check_manager_validation

  def index
  end

  protected

  def check_manager_validation
    authorize User, :check_manager? , policy_class: ManagersPolicy
  end
end
