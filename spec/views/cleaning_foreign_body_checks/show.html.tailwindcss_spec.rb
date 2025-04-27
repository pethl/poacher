require 'rails_helper'

RSpec.describe "cleaning_foreign_body_checks/show", type: :view do
  before(:each) do
    assign(:cleaning_foreign_body_check, CleaningForeignBodyCheck.create!(
      milk_pipeline: false,
      cheese_vat: false,
      used_mill: false,
      cooler_moulds_tables: false,
      hand_equipment: false,
      blue_food_contact_equipment: false,
      plastic_sleeves: false,
      metal_shovels: false,
      aprons: false,
      drain_lower_level: false,
      drain_upper_level: false,
      presses: false,
      sinks: false,
      floor_difficult_areas: false,
      footbaths: false,
      internal_door_handles: false,
      change_chlorine: false,
      floor_under_handwash: false,
      compressors: false,
      additional_comments: "MyText",
      staff: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
