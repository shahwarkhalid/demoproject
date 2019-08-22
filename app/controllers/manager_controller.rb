# frozen_string_literal: true

class ManagerController < ApplicationController
  before_action :validate_manager!

  def index
    graph_stats
  end

  protected

  def validate_manager!
    redirect_to root_url unless current_user.manager?
  end
end
