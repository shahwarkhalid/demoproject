# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[edit update enable_disable_user]
  before_action :authenticate_admin

  def index
    @users = User.where.not(id: current_user.id).order(:id).page(params[:page])
    @roles = Role.all
    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)
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

  def edit; end

  def update
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
        format.html { redirect_to admin_users_url, notice: 'User status successfully updated.' }
      end
    end
  end

  def search
    @role = params[:role]
    @name = params[:name]
    @users = if @role == 'all' && @name == 'Search User'
               User.all.where.not(id: current_user.id).order(:id).page(params[:page])
             elsif @role == 'all'
               User.all.where.not(id: current_user.id).where('name like ?', '%' + @name + '%').order(:id).page(params[:page])
             elsif @name == 'Search User'
               User.where(role: @role).where.not(id: current_user.id).order(:id).page(params[:page])
             else
               User.where(role: @role).where.not(id: current_user.id).where('name LIKE ?', '%' + @name + '%').order(:id).page(params[:page])
             end
    respond_to do |format|
      format.js
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

  def authenticate_admin
    render :index if !current_user.role.present? || !current_user.role == 'admin'
  end
end
