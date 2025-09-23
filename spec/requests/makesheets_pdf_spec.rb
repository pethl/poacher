# spec/requests/makesheets_pdf_spec.rb
# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Makesheet PDF", type: :request do
  let(:user) { create(:user) }
  let!(:makesheet) { create(:makesheet, make_date: Date.current) }

  before do
    sign_in user
    # Optional: silence mailers triggered by user creation
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    allow(UserMailer).to receive_message_chain(:new_user_notification, :deliver_later)
  end

  it "returns a valid PDF for a fresh makesheet" do
    get print_makesheet_pdf_path(makesheet) # add format: :pdf if needed

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body).to start_with("%PDF")
    expect(response.body).not_to match(/(We're sorry|Routing Error|RecordNotFound)/i)
  end

  it "returns valid PDFs for existing (fixture/seed) makesheets" do
    existing_ids = Makesheet.order(:id).limit(5).pluck(:id)
    skip "No existing makesheets found in test DB" if existing_ids.empty?

    tested_count = 0

    aggregate_failures "existing makesheet PDFs" do
      existing_ids.each do |id|
        get print_makesheet_pdf_path(id)

        expect(response).to have_http_status(:ok), "Expected 200 for makesheet ##{id}, got #{response.status}"
        expect(response.media_type).to eq("application/pdf"), "Wrong media_type for makesheet ##{id}"
        expect(response.body).to start_with("%PDF"), "Body did not start with %PDF for makesheet ##{id}"
        expect(response.body).not_to match(/(We're sorry|Routing Error|RecordNotFound)/i),
          "Error page content detected for makesheet ##{id}"

        tested_count += 1
      end
    end

    puts "\n📊 Tested #{tested_count} existing makesheet PDF#{'s' unless tested_count == 1}\n"
  end
end



