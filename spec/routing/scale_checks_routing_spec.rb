require "rails_helper"

RSpec.describe ScaleChecksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/scale_checks").to route_to("scale_checks#index")
    end

    it "routes to #new" do
      expect(get: "/scale_checks/new").to route_to("scale_checks#new")
    end

    it "routes to #show" do
      expect(get: "/scale_checks/1").to route_to("scale_checks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/scale_checks/1/edit").to route_to("scale_checks#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/scale_checks").to route_to("scale_checks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/scale_checks/1").to route_to("scale_checks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/scale_checks/1").to route_to("scale_checks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/scale_checks/1").to route_to("scale_checks#destroy", id: "1")
    end
  end
end
