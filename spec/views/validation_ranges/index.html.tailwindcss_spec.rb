require 'rails_helper'

RSpec.describe "validation_ranges/index", type: :view do
  before(:each) do
    assign(:validation_ranges, [
      build_stubbed(
        :validation_range,
        target_model: "Makesheet",
        field_name: "milk_used",
        min_value: 4000.0,
        max_value: 8000.0,
        active: true
      ),
      build_stubbed(
        :validation_range,
        target_model: "Makesheet",
        field_name: "salt_weight_net",
        min_value: 5.0,
        max_value: 20.0,
        active: true
      )
    ])
  end

  it "renders a list of validation_ranges" do
    render

    expect(rendered).to include("milk_used")
    expect(rendered).to include("salt_weight_net")
    expect(rendered).to include("4000.0")
    expect(rendered).to include("8000.0")
    expect(rendered).to include("5.0")
    expect(rendered).to include("20.0")
  end
end