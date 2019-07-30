# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_authorization
  include Pundit
  protect_from_forgery

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name status])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name age address status])
  end

  def after_sign_in_path_for(_resource)
    if current_user.role == 'admin'
      admin_index_url
    elsif current_user.role == 'manager'
      manager_index_url
    elsif current_user.role == 'user'
      user_index_url
    end
  end

  def user_authorization
    flash[:alert] = 'You are not authorized to access this.'
    if current_user.role == 'admin'
     redirect_to(request.referrer || admin_index_path)
    elsif current_user.role == 'manager'
     redirect_to(request.referrer || manager_index_path)
    elsif current_user.role == 'user'
     redirect_to(request.referrer || user_index_path)
    end
  end
end
