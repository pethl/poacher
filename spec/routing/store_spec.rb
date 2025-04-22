# spec/routing/store_spec.rb
require 'rails_helper'

RSpec.describe 'Store section routes', type: :routing do
  context 'Store homepage access' do
    it 'routes to makesheets#graded_blackboard' do
      expect(get: '/makesheets/graded_blackboard').to route_to(controller: 'makesheets', action: 'graded_blackboard')
    end
  end

  context 'Turn creation' do
    it 'routes to turns#new' do
      expect(get: '/turns/new').to route_to(controller: 'turns', action: 'new')
    end
  end

  context 'Grading workflow' do
    it 'routes to grading_notes#preload' do
      expect(get: '/grading_notes/preload').to route_to(controller: 'grading_notes', action: 'preload')
    end

    it 'routes to grading_notes#index' do
      expect(get: '/grading_notes').to route_to(controller: 'grading_notes', action: 'index')
    end
  end
end
