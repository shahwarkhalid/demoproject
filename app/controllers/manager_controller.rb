# frozen_string_literal: true

class ManagerController < ApplicationController
  before_action :validate_manager!

  def index; end

  protected

  def validate_manager!
    redirect_to root_url if !current_user.manager?
  end
end
