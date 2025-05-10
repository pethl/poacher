# spec/features/auth/user_sign_out_spec.rb

require 'rails_helper'

RSpec.feature "UserSignOut", type: :feature do
  let!(:user) { create(:user) }

  scenario "user logs out and sees goodbye message" do
    login_user(user)

    # Click logout via the sign-out link (desktop or mobile)
    find("a[href='/users/sign_out']", match: :first).click

    expect(current_path).to eq(goodbye_path)
    expect(page).to have_content("You have been signed out")
  end
end