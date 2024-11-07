class ApplicationController < ActionController::Base
  #before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  #include AbstractController::Rendering
  helper_method :is_admin?
 

  def is_admin?
    user_signed_in? ? current_user.admin : false
  end  
end
