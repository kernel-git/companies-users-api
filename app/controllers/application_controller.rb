# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from AbstractController::ActionNotFound, with: :not_found
  # rescue_from ActionController::ParameterMissing, with: :request_invalid

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email])
  end

  def not_found
    render json: { status: 404, message: 'not found' }, status: 404
  end

  # def request_invalid
  #   render json: { status: 400, message: 'bad request'  }
  # end
end
