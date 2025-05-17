require 'rails_helper'

RSpec.describe "VacuumPouchCalculators", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/vacuum_pouch_calculator/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/vacuum_pouch_calculator/create"
      expect(response).to have_http_status(:success)
    end
  end

end
