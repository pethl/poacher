# spec/routing/office_spec.rb
require 'rails_helper'

RSpec.describe 'Office section routes', type: :routing do
  context 'Office section resource access' do
    it 'routes to staffs#index' do
      expect(get: '/staffs').to route_to(controller: 'staffs', action: 'index')
    end

    it 'routes to contacts#index' do
      expect(get: '/contacts').to route_to(controller: 'contacts', action: 'index')
    end

    it 'routes to users#index' do
      expect(get: '/users').to route_to(controller: 'users', action: 'index')
    end

    it 'routes to references#index' do
      expect(get: '/references').to route_to(controller: 'references', action: 'index')
    end

    it 'routes to calculations#index' do
      expect(get: '/calculations').to route_to(controller: 'calculations', action: 'index')
    end

    it 'routes to butter_stocks#index' do
      expect(get: '/butter_stocks').to route_to(controller: 'butter_stocks', action: 'index')
    end

    it 'routes to samples#index' do
      expect(get: '/samples').to route_to(controller: 'samples', action: 'index')
    end

    it 'routes to milk_quality_monitors#index' do
      expect(get: '/milk_quality_monitors').to route_to(controller: 'milk_quality_monitors', action: 'index')
    end

    it 'routes to palletised_distributions#index' do
      expect(get: '/palletised_distributions').to route_to(controller: 'palletised_distributions', action: 'index')
    end
  end
end
