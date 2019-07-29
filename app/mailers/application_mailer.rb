# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'gvscontactus@gmail.com'
  layout 'mailer'
end
