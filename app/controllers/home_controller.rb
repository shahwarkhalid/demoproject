# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user.role == 'admin'
      redirect_to admin_users_url
    elsif current_user.role == 'manager'
      redirect_to manager_index_url
    elsif current_user.role == 'user'
      redirect_to user_index_url
    end
  end
end
