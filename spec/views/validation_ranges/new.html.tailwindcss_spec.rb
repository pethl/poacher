require "rails_helper"

RSpec.describe "validation_ranges/new", type: :view do
  before do
    assign(
      :validation_range,
      ValidationRange.new(
        target_model: "Makesheet",
        active: true
      )
    )

    assign(:model_name, "Makesheet")
    assign(:field_options, %w[milk_used salt_weight_net])
  end

  it "renders the new validation range form" do
    render

    assert_select "form[action=?][method=?]", validation_ranges_path, "post" do
      assert_select "input[type=hidden][name=?]", "validation_range[target_model]"

      assert_select "select[name=?]", "validation_range[field_name]"

      assert_select "input[name=?]", "validation_range[min_value]"

      assert_select "input[name=?]", "validation_range[max_value]"

      assert_select "input[type=radio][name=?]", "validation_range[active]", count: 2
    end
  end
end