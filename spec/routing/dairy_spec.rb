# spec/routing/dairy_spec.rb
require 'rails_helper'

RSpec.describe 'Dairy section routes', type: :routing do
  context 'Dairy homepage access' do
    it 'routes to dairy_home' do
      expect(get: '/pages/dairy_home').to route_to(controller: 'pages', action: 'dairy_home')
    end
  end

  context 'Makesheet creation with presets' do
    it 'routes to new makesheet (Standard 20kgs)' do
      expect(get: '/makesheets/new?make_type=Standard&weight_type=Standard+%2820kgs%29').to route_to(
        controller: 'makesheets',
        action: 'new',
        make_type: 'Standard',
        weight_type: 'Standard (20kgs)'
      )
    end

    it 'routes to new makesheet (Red Half Truckle)' do
      expect(get: '/makesheets/new?make_type=Red&weight_type=Half+Truckle+%2810kgs%29').to route_to(
        controller: 'makesheets',
        action: 'new',
        make_type: 'Red',
        weight_type: 'Half Truckle (10kgs)'
      )
    end

    it 'routes to new makesheet (P50 20kgs)' do
      expect(get: '/makesheets/new?make_type=P50&weight_type=Standard+%2820kgs%29').to route_to(
        controller: 'makesheets',
        action: 'new',
        make_type: 'P50',
        weight_type: 'Standard (20kgs)'
      )
    end
  end

  context 'General makesheet access' do
    it 'routes to makesheets index' do
      expect(get: '/makesheets').to route_to(controller: 'makesheets', action: 'index')
    end

    it 'routes to makesheets monthly_summary' do
      expect(get: '/makesheets/monthly_summary').to route_to(controller: 'makesheets', action: 'monthly_summary')
    end
  end

  context 'Makesheet batch_turns route' do
    it 'routes to makesheets#batch_turns' do
      expect(get: '/makesheets/42/batch_turns').to route_to(controller: 'makesheets', action: 'batch_turns', id: '42')
    end
  end
end
