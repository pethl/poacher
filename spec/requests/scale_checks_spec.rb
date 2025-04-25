require 'rails_helper'

RSpec.describe "ScaleChecks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/scale_checks/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/scale_checks/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/scale_checks/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/scale_checks/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
