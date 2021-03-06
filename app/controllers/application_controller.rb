class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include UsersHelper

  protected

   # def configure_permitted_parameters
      #added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      #devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      #devise_parameter_sanitizer.permit :account_update, keys: added_attrs
   # end
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end
end
