class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Corrected method name and parameter sanitizer
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private

  def handle_error(error)
    logger.error "Error: #{error.message}"
    logger.error error.backtrace.join("\n")

    respond_to do |format|
      format.html { redirect_to root_path, alert: 'An error has occurred.' }
      format.json { render json: { error: error.message }, status: :internal_server_error }
    end
  end
end
