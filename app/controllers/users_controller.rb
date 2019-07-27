# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit_user update_user enable_disable_user]
  before_action :authenticate_admin
  def index; end

  def all_users
    @users = User.where.not(id: current_user.id)
  end

  def new
    @user = User.new
  end

  def edit_user; end

  def update_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to allusers_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: allusers_url }
      else
        format.html { render :edit_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def enable_disable_user
    @user.status = if @user.status?
                     false
                   else
                     true
                   end
    @user.save(validate: false)
    if current_user.id == @user.id
      sign_out_and_redirect(current_user)
    else
      respond_to do |format|
        format.html { redirect_to allusers_url, notice: 'User status successfully updated.' }
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

  def authenticate_admin
    render :index if !current_user.role.present? || !current_user.role == 'admin'
  end
end
