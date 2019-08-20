# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to(redirect_user)
  end
end
