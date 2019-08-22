# frozen_string_literal: true

require "#{Rails.root}/lib/json_web_token.rb"
class ApiController < ActionController::API
  before_action :authenticate_user, unless: :authentication_controller?
  before_action :authorize_request

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_authorization
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def user_authorization
    render json: 'You are not authorized to access this.'
  end

  def authenticate_user
    render json: 'you need to sign in to continue' unless user_signed_in?
  end

  def authentication_controller?
    is_a?(::AuthenticationController)
  end

  def record_not_found
    render json: 'record not found', status: :not_found
  end
end
