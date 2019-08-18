# frozen_string_literal: true

class ApiController < ActionController::API
  # skip_before_action :verify_authenticity_token
  # skip_before_action :authenticate_user!
  # before_action :authenticate_api_key!
  # before_action :authenticate_user_from_token!
  # protect_from_forgery with: :null_session

  # protected

  # def current_user
  #   @resource
  # end

  # def user_signed_in?
  #   !@resource.nil?
  # end

  # private

  # def authenticate_user_from_token!
  #   @resource ||= user_with_key(apikey_from_request).where(email: claims[0]['user']).first
  #   if @resource.nil?
  #     raise Pundit::NotAuthorizedError.new('Unable to deserialize JWT token.')
  #   end
  # rescue StandardError => e
  #   Rails.logger.error e
  #   raise Pundit::NotAuthorizedError.new(e)
  # end

  # def authenticate_api_key!
  #   if apikey_from_request.present?
  #     unless user_with_key(apikey_from_request).present?
  #       raise Pundit::NotAuthorizedError.new('Unable to verify the apii key.')
  #     end
  #   end
  # end

  # def claims(token = token_from_request, key: shared_key)
  #   JWT.decode(token, key, true)
  # rescue JWT::DecodeError => e
  #   raise Pundit::NotAuthorizedError.new(e)
  # end

  # def jwt_token(user, key: shared_key)
  #   expires = (DateTime.now + 1.day).to_i
  #   JWT.encode({user: user.email, exp: expires}, key, 'HS256')
  # end

  # def token_from_request
  #   # Accepts the token either from the header or a query var
  #   # Header authorization must be in the following format
  #   # Authorization: Bearer {yourtokenhere}
  #   auth_header = request.headers['Authorization']
  #   token = auth_header.try(:split, ' ').try(:last)
  #   unless Rails.env.production?
  #     if token.to_s.empty?
  #       token = request.parameters.try(:[], 'token')
  #     end
  #   end
  #   token
  # end

  # def apikey_from_request
  #   # Accepts the ApiKey either from the header or a query var
  #   # Header ApiKey must be in the following format
  #   # ApiKey: {yourkeyhere}
  #   key = request.headers.try(:[], 'ApiKey').try(:split, ' ').try(:last)
  #   if !Rails.env.production? && key.blank?
  #     key = request.parameters.try(:[], 'apikey')
  #   end
  #   key
  # end

  # def shared_key
  #   user_secret.tap do |key|
  #     raise Pundit::NotAuthorizedError.new('Unable to verify the secret.') if key.blank?
  #   end
  # end

  # def user_secret
  #   return if apikey_from_request.nil?
  #   user_with_key(userkey_from_request).first.try(:shared_secret)
  # end

  # def user_with_key(key)
  #   return if apikey_from_request.nil?
  #   User.where(private_key: key).where('private_key_expires > ?', Time.zone.now)
  # end
end
