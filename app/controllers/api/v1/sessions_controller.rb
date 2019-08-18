# frozen_string_literal: true

require "#{Rails.root}/lib/json_web_token.rb"
class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json
  def create
    # self.resource = warden.authenticate!(auth_options)
    @user = User.find_for_database_authentication(email: params[:email])
    if @user.valid_password?(params[:password])
      sign_in(@user)
    else
      render json: { errors: ['Invalid Username/Password'] }, status: :unauthorized
    end
    @user.update_attributes(session_attributes)
    # @user.shared_secret = session_attributes[:shared_secret]
    # @user.token_expires = session_attributes[:token_expires]
    render json: { token: generate_token(@user) }
  end

  def destroy
    current_user.update_attributes(shared_secret: nil, token_expires: nil)
    super
  end

    private

  def generate_token(resource)
    JWT.encode(token_payload(resource), resource.shared_secret, 'HS256')
  end

  def token_payload(resource)
    { user: resource.email, exp: 200_000 }
  end

  def session_attributes
    {
      shared_secret: create_secret,
      token_expires: 1.week.from_now
    }
  end

  def create_secret
    SecureRandom.hex(127)
  end
  end
