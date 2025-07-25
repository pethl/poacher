require 'rails_helper'

RSpec.describe "validation_ranges/index", type: :view do
  before(:each) do
    assign(:validation_ranges, [
      ValidationRange.create!(
        field_name: "Field Name",
        min_value: 2.5,
        max_value: 3.5,
        active: false
      ),
      ValidationRange.create!(
        field_name: "Field Name",
        min_value: 2.5,
        max_value: 3.5,
        active: false
      )
    ])
  end

  it "renders a list of validation_ranges" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Field Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
