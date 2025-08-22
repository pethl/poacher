class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:goodbye]
  around_action :assign_current_user

  #include AbstractController::Rendering
  helper_method :is_admin?
 
  def is_admin?
    user_signed_in? ? current_user.admin : false
  end  

  def after_sign_in_path_for(resource)
     root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    goodbye_path
  end


  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :password_confirmation, :current_password])
  end

  private

    def assign_current_user
      Thread.current[:current_user] = current_user
      yield
    ensure
      Thread.current[:current_user] = nil
    end

end 
