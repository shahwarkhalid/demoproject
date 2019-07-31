# frozen_string_literal: true

class UserController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def index; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_index_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
