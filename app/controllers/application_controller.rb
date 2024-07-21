class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery unless: -> { request.format.json? }
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    
    protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username birth_date])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[name username birth_date])
    end
end
