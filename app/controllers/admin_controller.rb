# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :validate_admin!
  def index; end

  protected

  def validate_admin!
    redirect_to root_url unless current_user.admin?
  end
end
