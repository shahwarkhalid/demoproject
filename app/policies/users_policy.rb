# frozen_string_literal: true

class UsersPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def enable_disable_user?
    user.admin?
  end

  def search?
    user.admin?
  end

  def check_admin?
    user.admin?
  end
end
