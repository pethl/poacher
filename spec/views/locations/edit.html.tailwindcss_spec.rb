require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  let(:location) {
    Location.create!(
      name: "MyString",
      location_type: "MyString",
      active: false
    )
  }

  before(:each) do
    assign(:location, location)
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(location), "post" do

      assert_select "input[name=?]", "location[name]"

      assert_select "input[name=?]", "location[location_type]"

      assert_select "input[name=?]", "location[active]"
    end
  end
end
