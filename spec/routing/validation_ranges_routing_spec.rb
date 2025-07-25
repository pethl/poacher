require "rails_helper"

RSpec.describe ValidationRangesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/validation_ranges").to route_to("validation_ranges#index")
    end

    it "routes to #new" do
      expect(get: "/validation_ranges/new").to route_to("validation_ranges#new")
    end

    it "routes to #show" do
      expect(get: "/validation_ranges/1").to route_to("validation_ranges#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/validation_ranges/1/edit").to route_to("validation_ranges#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/validation_ranges").to route_to("validation_ranges#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/validation_ranges/1").to route_to("validation_ranges#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/validation_ranges/1").to route_to("validation_ranges#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/validation_ranges/1").to route_to("validation_ranges#destroy", id: "1")
    end
  end
end
