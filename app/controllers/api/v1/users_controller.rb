# frozen_string_literal: true

class Api::V1::UsersController < ApiController
  before_action :set_user, only: %i[show update]
  before_action :authorise_user
  skip_before_action :authorise_user, only: %i[edit_profile show_profile]

  def index
    render json: User.search_users(params, current_user).page(params[:page])
  end

  def show
    render json: @user
  end

  def update
    @user.update(user_params)
    render json: @user
  end

  def edit_profile
    current_user.update(user_params)
    render json: current_user
  end

  def show_profile
    render json: current_user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorise_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def user_params
    params.permit(:name, :age, :address, :role, :image)
  end
end
