# spec/features/auth/user_sign_up_spec.rb
require 'rails_helper'

RSpec.feature "UserSignUp", type: :feature do
  scenario "user signs up successfully and is logged in" do
    expect {
      sign_up_user(email: "test@example.com", password: "password123")
    }.to change(User, :count).by(1)

    expect(current_path).to eq(root_path)
    expect(page).to have_content("Welcome! You have signed up successfully.")
  end
end
