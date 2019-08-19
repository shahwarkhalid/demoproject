# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  include Pundit
  protect_from_forgery

  rescue_from Pundit::NotAuthorizedError, with: :user_authorization
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  rescue_from ActiveRecord::StatementInvalid, with: :rescue_from_fk_contraint

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name status image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name age address status image])
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

  def show_errors
    flash[:alert] = 'Record not found'
    redirect_to root_url
  end

  def page_not_found
    render :not_found
  end

  def projects_controller?
    is_a?(::ProjectsController)
  end

  def payments_controller?
    is_a?(::PaymentsController)
  end

  def rescue_from_fk_contraint
    flash[:alert] = 'Cannot Delete This Project'
    redirect_to root_url
  end
end
