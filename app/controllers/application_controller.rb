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
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name status image role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name age address status image])
  end

  def after_sign_in_path_for(_resource)
    redirect_user
  end

  def user_authorization
    flash[:alert] = 'You are not authorized to access this.'
    redirect_to(redirect_user)
  end

  def show_errors
    flash[:alert] = 'Record not found'
    redirect_to root_url
  end

  def page_not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end

  def redirect_user
    if current_user.role == 'admin'
      admin_index_path
    elsif current_user.role == 'manager'
      manager_index_path
    elsif current_user.role == 'user'
      user_index_path
    end
  end

  def graph_stats
    @top_projects = Project.top_projects
    @bottom_projects = Project.bottom_projects
    @monthly_timelog_stats = Timelog.monthly_stats
    @monthly_payment_stats = Payment.monthly_stats
  end
end
