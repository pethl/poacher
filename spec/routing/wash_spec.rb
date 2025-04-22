# spec/routing/wash_spec.rb
require 'rails_helper'

RSpec.describe 'Wash section routes', type: :routing do
  context 'Wash homepage access' do
    it 'routes to washes#index' do
      expect(get: '/washes').to route_to(controller: 'washes', action: 'index')
    end
  end
end
