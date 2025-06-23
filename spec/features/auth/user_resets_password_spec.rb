# spec/features/auth/user_resets_password_spec.rb
require 'rails_helper'

RSpec.feature "UserResetsPassword", type: :feature do

  before do
    Rails.application.env_config["action_dispatch.show_exceptions"] = :none
  end

  scenario "user resets their password successfully" do
    user = create(:user, email: "test@example.com")

    visit new_user_password_path

    fill_in "Email", with: user.email
    click_button "Send Reset Instructions"

    # Simulate the email delivery
    open_email(user.email)
    expect(current_email.subject).to eq("Reset password instructions")
    current_email.click_link "Change my password"

    fill_in "New password", with: "newpassword123"
    fill_in "Confirm new password", with: "newpassword123"
    click_button "Update my password"

    expect(page).to have_content("Your password has been changed successfully. You are now signed in.")
  end
end


