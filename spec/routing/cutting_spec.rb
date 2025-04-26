# spec/routing/cutting_spec.rb
require 'rails_helper'

RSpec.describe 'Cutting Room section routes', type: :routing do

  context 'Picksheet states' do
    it 'routes to open picksheets' do
      expect(get: '/picksheets/open_picksheets').to route_to(controller: 'picksheets', action: 'open_picksheets')
    end

    it 'routes to assigned picksheets' do
      expect(get: '/picksheets/assigned_picksheets').to route_to(controller: 'picksheets', action: 'assigned_picksheets')
    end

    it 'routes to cutting picksheets' do
      expect(get: '/picksheets/cutting_picksheets').to route_to(controller: 'picksheets', action: 'cutting_picksheets')
    end
  end


  context 'Picksheet core actions' do
    it 'routes to new picksheet' do
      expect(get: '/picksheets/new').to route_to(controller: 'picksheets', action: 'new')
    end

    it 'routes to daily cheese manifest' do
      expect(get: '/picksheets/daily_cheese_manifest').to route_to(controller: 'picksheets', action: 'daily_cheese_manifest')
    end

    it 'routes to dispatch and collection' do
      expect(get: '/picksheets/dispatch_and_collection').to route_to(controller: 'picksheets', action: 'dispatch_and_collection')
    end
  end


  context 'Cutting tools and monitoring' do
    it 'routes to traceability records index' do
      expect(get: '/traceability_records').to route_to(controller: 'traceability_records', action: 'index')
    end

    it 'routes to batch weights index' do
      expect(get: '/batch_weights').to route_to(controller: 'batch_weights', action: 'index')
    end

    it 'routes to chillers index' do
      expect(get: '/chillers').to route_to(controller: 'chillers', action: 'index')
    end

    it 'routes to breakages index' do
      expect(get: '/breakages').to route_to(controller: 'breakages', action: 'index')
    end
    

    describe "scale checks routing" do
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
end