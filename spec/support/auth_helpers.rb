# spec/support/auth_helpers.rb
module AuthHelpers

    def sign_up_user(email: "test@example.com", password: "password123")
      visit new_user_registration_path
  
      fill_in "First name", with: "Testy"
      fill_in "Last name", with: "McTestface"
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
  
      click_button "Sign up"
    end
  
    def login_user(user)
      if user.respond_to?(:confirmed?) && !user.confirmed?
        user.confirm
        user.save! # 👈 ADD THIS so the DB has the confirmed user
      end
   
    
      visit new_user_session_path
     
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password123"
      click_button "Sign in"
    end
    
  
    def logout_user
      find("i.fa-arrow-right-from-bracket").click
    end

    def reset_password_for(user, new_password: "newpassword123")
      # Generate a reset token
      raw_token, enc_token = Devise.token_generator.generate(User, :reset_password_token)
  
      # Save it to user
      user.update!(
        reset_password_token: enc_token,
        reset_password_sent_at: Time.current
      )
  
      # Visit the password reset page
      visit edit_user_password_path(reset_password_token: raw_token)
  
      # Fill in the new password
      fill_in "New password", with: new_password
      fill_in "Confirm new password", with: new_password
      click_button "Change my password"
    end

    # def confirm_user(user)
    #   raw_token, enc_token = Devise.token_generator.generate(User, :confirmation_token)
  
    #   user.update!(
    #     confirmation_token: enc_token,
    #     confirmation_sent_at: Time.current
    #   )
  
    #   visit user_confirmation_path(confirmation_token: raw_token)
    # end

end
  