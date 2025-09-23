require "rails_helper"

RSpec.describe "locations/edit", type: :view do
  before do
    # Make the helper deterministic in the spec
    allow(view).to receive(:location_type_options)
      .and_return([["Aisle", "aisle"], ["Shed", "shed"]])

    assign(:location, Location.new(
      id: 123,                # so path helper works without hitting DB
      name: "MyString",
      location_type: "aisle", # must match one of the stubbed options
      active: false
    ))
  end

  it "renders the edit location form" do
    render

    loc = assigns(:location)

    assert_select "form[action=?][method=?]", location_path(loc), "post" do
      # name input
      assert_select 'input[type="text"][name=?][value=?]', "location[name]", loc.name

      # location_type SELECT with the current value selected
      assert_select 'select[name=?]', "location[location_type]" do
        # prompt may exist but should NOT be selected on edit
        assert_select 'option[value=""]', text: /Please select/i, count: 0

        # selected option matches the record's value
        assert_select 'option[selected][value=?]', loc.location_type, 1
      end

      # active checkbox — ensure it's present and NOT checked
      assert_select 'input[type="checkbox"][name=?]', "location[active]"
      assert_select 'input[type="checkbox"][name=?][checked]', "location[active]", count: 0
    end
  end
end
