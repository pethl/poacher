require 'rails_helper'

RSpec.describe "cleaning_foreign_body_checks/edit", type: :view do
  let(:cleaning_foreign_body_check) {
    CleaningForeignBodyCheck.create!(
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
    )
  }

  before(:each) do
    assign(:cleaning_foreign_body_check, cleaning_foreign_body_check)
  end

  it "renders the edit cleaning_foreign_body_check form" do
    render

    assert_select "form[action=?][method=?]", cleaning_foreign_body_check_path(cleaning_foreign_body_check), "post" do

      assert_select "input[name=?]", "cleaning_foreign_body_check[milk_pipeline]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[cheese_vat]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[used_mill]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[cooler_moulds_tables]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[hand_equipment]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[blue_food_contact_equipment]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[plastic_sleeves]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[metal_shovels]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[aprons]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[drain_lower_level]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[drain_upper_level]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[presses]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[sinks]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[floor_difficult_areas]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[footbaths]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[internal_door_handles]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[change_chlorine]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[floor_under_handwash]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[compressors]"

      assert_select "textarea[name=?]", "cleaning_foreign_body_check[additional_comments]"

      assert_select "input[name=?]", "cleaning_foreign_body_check[staff_id]"
    end
  end
end
