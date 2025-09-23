# frozen_string_literal: true
require "rails_helper"

RSpec.describe "LocationsController#print_markers", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
    # keep background mails quiet
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    allow(UserMailer).to receive_message_chain(:new_user_notification, :deliver_later)
  end

  def expect_pdf_ok!
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body).to start_with("%PDF")
  end

  it "returns a PDF for ALL aisles" do
    # Return a tiny valid PDF without touching the real implementation
    service = instance_double("AisleMarkerPdfService", generate: "%PDF-1.4\n%markers-all\n")
    expect(AisleMarkerPdfService).to receive(:new).with(any_args).and_return(service)

    get print_markers_locations_path, params: { aisle_name: "ALL" }

    expect_pdf_ok!
  end

  it "returns a PDF for a specific aisle/side" do
    # If your controller filters by names like `Shed 1 - Aisle 1 Left`
    # you can create one real location to make the param realistic (optional):
    create(:location, name: "Shed 1 - Aisle 1 Left Col 1")

    service = instance_double("AisleMarkerPdfService", generate: "%PDF-1.4\n%markers-one-aisle\n")
    expect(AisleMarkerPdfService).to receive(:new).with(any_args).and_return(service)

    get print_markers_locations_path, params: { aisle_name: "Shed 1 - Aisle 1 Left" }

    expect_pdf_ok!
  end
end
