# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  include Pundit
  protect_from_forgery

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name status])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name age address status])
  end

  def after_sign_in_path_for(_resource)
    if current_user.role == 'admin'
      admin_users_url
    else
      root_url
    end
  end
end
