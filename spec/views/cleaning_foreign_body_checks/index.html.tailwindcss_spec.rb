require 'rails_helper'

RSpec.describe "cleaning_foreign_body_checks/index", type: :view do
  before(:each) do
    assign(:cleaning_foreign_body_checks, [
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
      ),
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
    ])
  end

  it "renders a list of cleaning_foreign_body_checks" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
