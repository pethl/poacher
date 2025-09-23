# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Picksheets PDF endpoints", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
    # quiet mailers
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    allow(UserMailer).to receive_message_chain(:new_user_notification, :deliver_later)
  end

  def expect_pdf_ok!
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body).to start_with("%PDF")
  end

  describe "#print_picksheet_pdf (single)" do
    let!(:picksheet) { create(:picksheet) }

    it "returns a PDF" do
      service = instance_double(PicksheetPdfService, generate: "%PDF-1.4\n%picksheet\n")
      expect(PicksheetPdfService).to receive(:new).with(picksheet).and_return(service)

      # no helper for this route; pass id via params
      get "/print_picksheet_pdf", params: { id: picksheet.id }

      expect_pdf_ok!
    end
  end

  describe "#print_manifest_pdf (collection)" do
    it "returns a PDF" do
      service = instance_double(PicksheetManifestPdfService, generate: "%PDF-1.4\n%manifest\n")
      allow(PicksheetManifestPdfService).to receive(:new).and_return(service)

      get print_manifest_pdf_picksheets_path

      expect_pdf_ok!
    end

    it "returns 500 if generation fails" do
      allow(PicksheetManifestPdfService).to receive(:new).and_return(instance_double(PicksheetManifestPdfService, generate: nil))

      get print_manifest_pdf_picksheets_path

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to match(/PDF generation failed/i)
    end
  end

  describe "#print_dispatch_pdf (collection)" do
    it "returns a PDF" do
      service = instance_double(PicksheetDispatchPdfService, generate: "%PDF-1.4\n%dispatch\n")
      allow(PicksheetDispatchPdfService).to receive(:new).and_return(service)

      get print_dispatch_pdf_picksheets_path

      expect_pdf_ok!
    end

    it "returns 500 if generation fails" do
      allow(PicksheetDispatchPdfService).to receive(:new).and_return(instance_double(PicksheetDispatchPdfService, generate: nil))

      get print_dispatch_pdf_picksheets_path

      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to match(/PDF generation failed/i)
    end
  end
end

