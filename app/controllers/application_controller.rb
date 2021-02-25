# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from AbstractController::ActionNotFound, with: :route_not_recognized
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email])
  end

  def not_found(exception)
    render json: { status: :not_found, error: exception.message }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { status: :unprocessable_entity, error: exception.record.errors }, status: :unprocessable_entity
  end

  def parameter_missing(exception)
    render json: { status: :bad_request, error: exception.message }, status: :bad_request
  end

  def route_not_recognized
    render json: { status: :bad_request, error: 'route not recognized' }, status: :bad_request
  end

  def not_authorized(exception)
    render json: { status: :forbidden, error: exception.message }, status: :forbidden
  end
end
