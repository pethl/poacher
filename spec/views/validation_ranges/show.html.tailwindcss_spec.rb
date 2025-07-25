require 'rails_helper'

RSpec.describe "validation_ranges/show", type: :view do
  before(:each) do
    assign(:validation_range, ValidationRange.create!(
      field_name: "Field Name",
      min_value: 2.5,
      max_value: 3.5,
      active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Field Name/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/false/)
  end
end
