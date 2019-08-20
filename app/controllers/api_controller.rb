# frozen_string_literal: true

class ApiController < ActionController::API
  before_action :authenticate_user

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_authorization

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
end
