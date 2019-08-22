# frozen_string_literal: true

class Admin::UsersController < AdminController
  before_action :set_user, only: %i[edit update enable_disable_user]

  def index
    @users = User.search_users(params, current_user).page(params[:page])
    @roles = Role.all

    authorize User, :check_admin?, policy_class: UsersPolicy
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)

    authorize @user, :check_admin?, policy_class: UsersPolicy

    respond_to do |format|
      if @user.save
        UserMailer.with(user: @user).welcome_email.deliver_now
        format.html { redirect_to admin_users_url, notice: 'User was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @user, :check_admin?, policy_class: UsersPolicy
  end

  def update
    authorize @user, :check_admin?, policy_class: UsersPolicy
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_url, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def enable_disable_user
    authorize @user, :check_admin?, policy_class: UsersPolicy
    @user.toggle!(:status)
    @user.save(validate: false)

    if current_user.id == @user.id
      sign_out_and_redirect(current_user)
    else
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: 'User status successfully updated.' }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :age, :address, :role)
  end

  def create_params
    params.require(:user).permit(:name, :age, :address, :role, :email, :password)
  end
end
