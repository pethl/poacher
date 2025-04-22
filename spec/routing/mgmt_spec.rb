# spec/routing/mgmt_spec.rb
require 'rails_helper'

RSpec.describe 'Management section routes', type: :routing do
  context 'Reports and overview access' do
    it 'routes to butter_makes#index' do
      expect(get: '/butter_makes').to route_to(controller: 'butter_makes', action: 'index')
    end

    it 'routes to makesheets#overview' do
      expect(get: '/makesheets/overview').to route_to(controller: 'makesheets', action: 'overview')
    end

    it 'routes to makesheets#monthly_summary' do
      expect(get: '/makesheets/monthly_summary').to route_to(controller: 'makesheets', action: 'monthly_summary')
    end

    it 'routes to market_sales#index' do
      expect(get: '/market_sales').to route_to(controller: 'market_sales', action: 'index')
    end

    it 'routes to invoices#index' do
      expect(get: '/invoices').to route_to(controller: 'invoices', action: 'index')
    end
  end
end

