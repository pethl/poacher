require "rails_helper"

RSpec.describe "validation_ranges/edit", type: :view do
  let(:validation_range) do
    build_stubbed(
      :validation_range,
      target_model: "Makesheet",
      field_name: "milk_used",
      min_value: 4000.0,
      max_value: 8000.0,
      active: true
    )
  end

  before do
    assign(:validation_range, validation_range)
    assign(:field_options, %w[milk_used salt_weight_net])
  end

  it "renders the edit validation range form" do
    render

    assert_select "form[action=?][method=?]", validation_range_path(validation_range), "post" do
      # Field name is displayed but submitted as a hidden field
      assert_select "input[type=hidden][name=?]", "validation_range[field_name]"

      assert_select "input[name=?]", "validation_range[min_value]"

      assert_select "input[name=?]", "validation_range[max_value]"

      assert_select "input[type=radio][name=?]", "validation_range[active]", count: 2
    end
  end
end