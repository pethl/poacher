# spec/services/aisle_marker_pdf_service_spec.rb
require "rails_helper"
require "pdf/reader"

RSpec.describe AisleMarkerPdfService do
  let!(:loc1) { create(:location) }
  let!(:loc2) { create(:location) }

  it "generates a valid PDF" do
    service = described_class.new([loc1, loc2])   # ← collection, not a String
    pdf = service.generate

    expect(pdf).to be_a(String)
    expect(pdf).to start_with("%PDF")
  end
end

