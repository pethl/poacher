require 'rails_helper'

RSpec.describe "validation_ranges/new", type: :view do
  before(:each) do
    assign(:validation_range, ValidationRange.new(
      field_name: "MyString",
      min_value: 1.5,
      max_value: 1.5,
      active: false
    ))
  end

  it "renders new validation_range form" do
    render

    assert_select "form[action=?][method=?]", validation_ranges_path, "post" do

      assert_select "input[name=?]", "validation_range[field_name]"

      assert_select "input[name=?]", "validation_range[min_value]"

      assert_select "input[name=?]", "validation_range[max_value]"

      assert_select "input[name=?]", "validation_range[active]"
    end
  end
end
