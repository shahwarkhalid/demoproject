class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    byebug
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  private

  def sign_up_params
    params.permit(:email, :password, :password_confirmation, :name, :status)
  end
end
