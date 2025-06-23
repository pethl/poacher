require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_email" do
    let(:user) { create(:user, first_name: "Lisa", email: "lisa@example.com") }
    let(:mail) { described_class.welcome_email(user) }

    it "includes user's first name or email" do
      expect(mail.body.encoded).to match(/Welcome.*(Lisa|lisa@example\.com)/)
    end

    it "sends to the correct user" do
      expect(mail.to).to eq([user.email])
    end

    it "has the correct subject" do
      expect(mail.subject).to eq("Welcome to Lincolnshire Poacher Cheese!")
    end

    it "includes sign in and forgot password URLs" do
      expect(mail.body.encoded).to include(new_user_session_url)
      expect(mail.body.encoded).to include(new_user_password_url)
    end
  end

  describe "new_user_notification" do
    context "when user has full name" do
      let(:user) { create(:user, first_name: "Lisa", last_name: "McUser", email: "lisa@example.com") }
      let(:mail) { described_class.new_user_notification(user) }

      it "sends to the admin email" do
        expect(mail.to).to eq(["pethicklisa@gmail.com"])
      end

      it "has the correct subject" do
        expect(mail.subject).to eq("New User Registered: #{user.full_name}")
      end

      it "includes user details in the body" do
        expect(mail.body.encoded).to include(user.email)
        expect(mail.body.encoded).to include(user.full_name)
      end

      it "includes a link to the admin users page" do
        expect(mail.body.encoded).to include(users_url)
      end
    end

    context "when user has no name" do
      let(:user) { create(:user, first_name: "", last_name: "", email: "noname@example.com") }
      let(:mail) { described_class.new_user_notification(user) }

      it "falls back to email in the subject" do
        expect(mail.subject).to eq("New User Registered: #{user.email}")
      end
    end
  end
end


