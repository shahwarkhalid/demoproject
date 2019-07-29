# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to Project Management System')
  end
end
