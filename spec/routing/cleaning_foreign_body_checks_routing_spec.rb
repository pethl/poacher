require "rails_helper"

RSpec.describe CleaningForeignBodyChecksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cleaning_foreign_body_checks").to route_to("cleaning_foreign_body_checks#index")
    end

    it "routes to #new" do
      expect(get: "/cleaning_foreign_body_checks/new").to route_to("cleaning_foreign_body_checks#new")
    end

    it "routes to #show" do
      expect(get: "/cleaning_foreign_body_checks/1").to route_to("cleaning_foreign_body_checks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cleaning_foreign_body_checks/1/edit").to route_to("cleaning_foreign_body_checks#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cleaning_foreign_body_checks").to route_to("cleaning_foreign_body_checks#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cleaning_foreign_body_checks/1").to route_to("cleaning_foreign_body_checks#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cleaning_foreign_body_checks/1").to route_to("cleaning_foreign_body_checks#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cleaning_foreign_body_checks/1").to route_to("cleaning_foreign_body_checks#destroy", id: "1")
    end
  end
end
