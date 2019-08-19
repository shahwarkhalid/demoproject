class Api::V1::UsersController < ApiController
  before_action :set_user, only: %i[show]
  before_action :authorise_user

  def index
    render json: User.search_users(params, current_user)
  end

  def show
    render json: @user
  end
  private

  def set_user
    @user = User.find_by_id(params[:id])
    render json: 'record not found', status: :not_found unless @user
  end

  def authorise_user
    authorize User, :check_admin?, policy_class: UsersPolicy
  end
end
