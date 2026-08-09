# spec/requests/vacuum_pouch_calculator_spec.rb
require "rails_helper"

RSpec.describe "VacuumPouchCalculator", type: :request do
  let(:user) { create(:user) }

  let!(:pouch) do
    Reference.create!(
      model: "VacuumPouchCalculator",
      group: "vacuum_pouches",
      value: "200 x 300",
      description: "12.5",
      active: true
    )
  end

  before do
    sign_in user
  end

  describe "GET /vacuum_pouch_calculator/new" do
    it "loads successfully" do
      get vacuum_pouch_calculator_new_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("200 x 300")
    end
  end

  describe "POST /vacuum_pouch_calculator" do
    it "renders an error when no pouch is selected" do
      post vacuum_pouch_calculator_path, params: {
        pouch_id: "",
        item_count: "10",
        total_weight: "1000"
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Please select a pouch size.")
    end

    it "renders an error when an invalid pouch is selected" do
      post vacuum_pouch_calculator_path, params: {
        pouch_id: "999999",
        item_count: "10",
        total_weight: "1000"
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Invalid pouch selected.")
    end

    it "calculates packaging and net weight" do
      post vacuum_pouch_calculator_path, params: {
        pouch_id: pouch.id,
        item_count: "10",
        total_weight: "1000"
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("200 x 300")
      expect(response.body).to include("875.0 g")
    end
  end
end