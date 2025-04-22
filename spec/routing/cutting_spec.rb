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
  end
end