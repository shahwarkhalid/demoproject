# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def check_user?
    user.user?
  end
end
