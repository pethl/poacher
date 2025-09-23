require "rails_helper"

RSpec.describe "locations/new", type: :view do
  it "renders new location form" do
    assign(:location, Location.new(name: "MyString", location_type: nil, active: false))

    render

    assert_select 'form[action=?][method=?]', locations_path, 'post' do
      assert_select 'input[type="text"][name=?]', 'location[name]'

      assert_select 'select[name=?]', 'location[location_type]' do
        # Prompt exists (value is blank). Don’t require [selected].
        assert_select 'option[value=""]', text: /Please select/i
        # Optional: ensure it’s the first option
        assert_select 'option:first-child', text: /Please select/i
      end

      # Rails renders a hidden field + the checkbox; target the checkbox explicitly
      assert_select 'input[type="checkbox"][name=?]', 'location[active]'
    end
  end
end

