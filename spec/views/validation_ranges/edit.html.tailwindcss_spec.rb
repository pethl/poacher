require 'rails_helper'

RSpec.describe "validation_ranges/edit", type: :view do
  let(:validation_range) {
    ValidationRange.create!(
      field_name: "MyString",
      min_value: 1.5,
      max_value: 1.5,
      active: false
    )
  }

  before(:each) do
    assign(:validation_range, validation_range)
  end

  it "renders the edit validation_range form" do
    render

    assert_select "form[action=?][method=?]", validation_range_path(validation_range), "post" do

      assert_select "input[name=?]", "validation_range[field_name]"

      assert_select "input[name=?]", "validation_range[min_value]"

      assert_select "input[name=?]", "validation_range[max_value]"

      assert_select "input[name=?]", "validation_range[active]"
    end
  end
end
