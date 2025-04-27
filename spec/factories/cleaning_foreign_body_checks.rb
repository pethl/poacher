FactoryBot.define do
  factory :cleaning_foreign_body_check do
    date { "2025-04-26" }
    milk_pipeline { false }
    cheese_vat { false }
    used_mill { false }
    cooler_moulds_tables { false }
    hand_equipment { false }
    blue_food_contact_equipment { false }
    plastic_sleeves { false }
    metal_shovels { false }
    aprons { false }
    drain_lower_level { false }
    drain_upper_level { false }
    presses { false }
    sinks { false }
    floor_difficult_areas { false }
    footbaths { false }
    internal_door_handles { false }
    change_chlorine { false }
    floor_under_handwash { false }
    compressors { false }
    additional_comments { "MyText" }
    staff { nil }
  end
end
