class UsersPolicy < ApplicationPolicy
  def check_admin?
    user.admin?
  end
end
