require "rails_helper"

RSpec.describe "validation_ranges/show", type: :view do
  before do
    creator = build_stubbed(
      :user,
      first_name: "Test",
      last_name: "Creator"
    )

    updater = build_stubbed(
      :user,
      first_name: "Test",
      last_name: "Updater"
    )

    assign(
      :validation_range,
      build_stubbed(
        :validation_range,
        target_model: "Makesheet",
        field_name: "milk_used",
        min_value: 4000.0,
        max_value: 8000.0,
        active: true,
        created_by: creator,
        updated_by: updater
      )
    )
  end

  it "renders the validation range attributes" do
    render

    expect(rendered).to include("milk_used")
    expect(rendered).to include("4000.0")
    expect(rendered).to include("8000.0")
    expect(rendered).to include("Active")
    expect(rendered).to include("Test Creator")
    expect(rendered).to include("Test Updater")
  end
end
