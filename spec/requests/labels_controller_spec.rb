# frozen_string_literal: true
require "rails_helper"

RSpec.describe "LabelsController", type: :request do
  let(:user) { create(:user) }

  before do
    # Every action here (bar show_pdf, not covered by this spec) requires :print_labels
    # on Makesheet — grant it directly rather than depending on a specific group's
    # place in the business matrix, which can change independently of this spec.
    join_group(user, "store")
    grant("store", "makesheet", :print_labels)

    sign_in user
    # keep mailers quiet in test
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    allow(UserMailer).to receive_message_chain(:new_user_notification, :deliver_later)
  end

  # tiny helper so we don't repeat ourselves
  def expect_pdf_ok!
    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/pdf")
    expect(response.body).to start_with("%PDF")
  end

  describe "#preview_single_cheese" do
    let!(:makesheet) { create(:makesheet) }

    it "responds with a valid PDF" do
      svc = instance_double(CheeseSingleLabelService, generate: "%PDF-1.4\n%preview\n")
      expect(CheeseSingleLabelService).to receive(:new).with(makesheet).and_return(svc)

      get preview_single_cheese_label_path(makesheet)

      expect_pdf_ok!
    end
  end

  describe "#print_single_cheese_label" do
    let!(:makesheet) { create(:makesheet) }

    it "invokes the printer service and redirects with notice" do
      svc = instance_double(CheeseSingleLabelService)
      expect(CheeseSingleLabelService).to receive(:new).with(makesheet).and_return(svc)
      expect(svc).to receive(:print).and_return(true)

      get print_single_cheese_label_path(makesheet)

      expect(response).to have_http_status(:found).or have_http_status(:see_other)
      # Optionally:
      # follow_redirect!
      # expect(flash[:notice]).to match(/Label sent to printer/i)
    end
  end

  describe "#print_cheese_labels" do
    let(:start_date) { Date.current - 1 }
    let(:end_date)   { Date.current }

    it "returns a PDF for the given date range" do
      create(:makesheet, make_date: start_date)
      create(:makesheet, make_date: end_date)

      svc = instance_double(CheeseMultiLabelService, generate: "%PDF-1.4\n%range\n")
      expect(CheeseMultiLabelService).to receive(:new).and_return(svc)

      get print_cheese_labels_path, params: { start_date:, end_date: }

      expect_pdf_ok!
    end

    it "redirects to the print wizard when dates are missing" do
      get print_cheese_labels_path, params: { start_date: "", end_date: "" }
      expect(response).to redirect_to(print_wizard_locations_path)
    end
  end

  describe "authorization" do
    let(:outsider) { create(:user) } # no group, no :print_labels grant

    before do
      sign_in outsider
    end

    it "is denied for a user without :print_labels on Makesheet" do
      makesheet = create(:makesheet)

      get preview_single_cheese_label_path(makesheet)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end
  end
end
