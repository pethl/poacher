class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @sign_in_url = new_user_session_url
    @forgot_password_url = new_user_password_url

    mail(to: @user.email, subject: "Welcome to Lincolnshire Poacher Cheese!")
  end

  def new_user_notification(user)
    @user = user
  
    mail(
      to: 'pethicklisa@gmail.com',
      subject: "New User Registered: #{@user.full_name.presence || @user.email}"
    )
  end
end

