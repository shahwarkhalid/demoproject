# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def after_update_path_for(_resource)
    if current_user.role == 'admin'
      admin_users_url
    elsif current_user.role == 'user'
      user_index_url
    else
      root_url
    end
  end
end
