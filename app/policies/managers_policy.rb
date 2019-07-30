# frozen_string_literal: true

class ManagersPolicy < ApplicationPolicy
  def check_manager?
    user.manager?
  end
end
