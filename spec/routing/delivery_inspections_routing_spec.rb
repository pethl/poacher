require "rails_helper"

RSpec.describe DeliveryInspectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/delivery_inspections").to route_to("delivery_inspections#index")
    end

    it "routes to #new" do
      expect(get: "/delivery_inspections/new").to route_to("delivery_inspections#new")
    end

    it "routes to #show" do
      expect(get: "/delivery_inspections/1").to route_to("delivery_inspections#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/delivery_inspections/1/edit").to route_to("delivery_inspections#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/delivery_inspections").to route_to("delivery_inspections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/delivery_inspections/1").to route_to("delivery_inspections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/delivery_inspections/1").to route_to("delivery_inspections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/delivery_inspections/1").to route_to("delivery_inspections#destroy", id: "1")
    end
  end
end
