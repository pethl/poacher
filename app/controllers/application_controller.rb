class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:goodbye]

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
    # Permit additional sign_up params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :encrypted_password])

     # Permit the email for sign in explicitly
     devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
    
    # If you allow editing account info as well:
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end 
