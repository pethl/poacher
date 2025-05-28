require 'rails_helper'

RSpec.describe "LocationAssignments", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/location_assignments/create"
      expect(response).to have_http_status(:success)
    end
  end

end
