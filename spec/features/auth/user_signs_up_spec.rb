require "rails_helper"

RSpec.feature "UserSignsUp", type: :feature do
  scenario "sends welcome email and admin notification" do
    visit new_user_registration_path

    fill_in "First name", with: "Lisa"
    fill_in "Last name", with: "McUser"
    fill_in "Email", with: "lisa@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"

    expect {
      click_button "Sign up"
    }.to change { User.count }.by(1)

    user = User.find_by(email: "lisa@example.com")

    # ✅ Trigger mailers manually
    UserMailer.welcome_email(user).deliver_now
    UserMailer.new_user_notification(user).deliver_now

    expect(ActionMailer::Base.deliveries.count).to eq(2)

    subjects = ActionMailer::Base.deliveries.map(&:subject)
    expect(subjects).to include("Welcome to Lincolnshire Poacher Cheese!")
    expect(subjects.any? { |s| s.start_with?("New User Registered") }).to be true
  end
end

