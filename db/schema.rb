# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_24_112939) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "batch_weights", force: :cascade do |t|
    t.date "date"
    t.bigint "makesheet_id"
    t.decimal "washed_batch_weight", precision: 7, scale: 2
    t.decimal "total_waste", precision: 7, scale: 2
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_batch_weights_on_created_by_id"
    t.index ["makesheet_id"], name: "index_batch_weights_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_batch_weights_on_updated_by_id"
  end

  create_table "breakages", force: :cascade do |t|
    t.date "date"
    t.boolean "breakage_occured"
    t.boolean "knife"
    t.boolean "cutting_board_cutting_wire"
    t.boolean "ringing_machine_cutting_wire"
    t.boolean "cutting_spring"
    t.integer "wire_broken_into_2"
    t.integer "wire_unwound"
    t.integer "other_number"
    t.string "other_desc"
    t.boolean "product_contaminated"
    t.string "action_taken"
    t.bigint "staff_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_breakages_on_created_by_id"
    t.index ["staff_id"], name: "index_breakages_on_staff_id"
    t.index ["updated_by_id"], name: "index_breakages_on_updated_by_id"
  end

  create_table "butter_makes", force: :cascade do |t|
    t.date "date"
    t.integer "cream"
    t.integer "make"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_butter_makes_on_created_by_id"
    t.index ["updated_by_id"], name: "index_butter_makes_on_updated_by_id"
  end

  create_table "butter_stocks", force: :cascade do |t|
    t.datetime "make_date"
    t.integer "todays_make"
    t.integer "fresh_spare_for_sale"
    t.integer "market_returns_salted"
    t.integer "market_returns_hm2"
    t.integer "market_returns_unsalted"
    t.integer "freezer_stock_salted"
    t.integer "freezer_stock_hm2"
    t.integer "freezer_stock_unsalted"
    t.integer "family_butter_salted"
    t.integer "family_butter_hm2"
    t.integer "family_butter_unsalted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_butter_stocks_on_created_by_id"
    t.index ["updated_by_id"], name: "index_butter_stocks_on_updated_by_id"
  end

  create_table "calculations", force: :cascade do |t|
    t.string "product"
    t.string "size"
    t.integer "weight"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_calculations_on_created_by_id"
    t.index ["updated_by_id"], name: "index_calculations_on_updated_by_id"
  end

  create_table "cheese_wash_records", force: :cascade do |t|
    t.bigint "makesheet_id", null: false
    t.date "date_batch_started"
    t.date "date_batch_finished"
    t.date "wash_date_1"
    t.integer "number_washed_1", default: 0
    t.date "wash_date_2"
    t.integer "number_washed_2", default: 0
    t.date "wash_date_3"
    t.integer "number_washed_3", default: 0
    t.date "wash_date_4"
    t.integer "number_washed_4", default: 0
    t.date "wash_date_5"
    t.integer "number_washed_5", default: 0
    t.date "wash_date_6"
    t.integer "number_washed_6", default: 0
    t.date "wash_date_7"
    t.integer "number_washed_7", default: 0
    t.date "wash_date_8"
    t.integer "number_washed_8", default: 0
    t.date "wash_date_9"
    t.integer "number_washed_9", default: 0
    t.date "wash_date_10"
    t.integer "number_washed_10", default: 0
    t.date "wash_date_11"
    t.integer "number_washed_11", default: 0
    t.date "wash_date_12"
    t.integer "number_washed_12", default: 0
    t.date "wash_date_13"
    t.integer "number_washed_13", default: 0
    t.date "wash_date_14"
    t.integer "number_washed_14", default: 0
    t.date "wash_date_15"
    t.integer "number_washed_15", default: 0
    t.date "wash_date_16"
    t.integer "number_washed_16", default: 0
    t.date "wash_date_17"
    t.integer "number_washed_17", default: 0
    t.date "wash_date_18"
    t.integer "number_washed_18", default: 0
    t.date "wash_date_19"
    t.integer "number_washed_19", default: 0
    t.date "wash_date_20"
    t.integer "number_washed_20", default: 0
    t.date "wash_date_21"
    t.integer "number_washed_21", default: 0
    t.date "wash_date_22"
    t.integer "number_washed_22", default: 0
    t.date "wash_date_23"
    t.integer "number_washed_23", default: 0
    t.date "wash_date_24"
    t.integer "number_washed_24", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_cheese_wash_records_on_created_by_id"
    t.index ["makesheet_id"], name: "index_cheese_wash_records_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_cheese_wash_records_on_updated_by_id"
  end

  create_table "chillers", force: :cascade do |t|
    t.date "date"
    t.decimal "chiller_1", precision: 5, scale: 2
    t.decimal "chiller_2", precision: 5, scale: 2
    t.string "action_taken"
    t.bigint "staff_id"
    t.text "signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_chillers_on_created_by_id"
    t.index ["staff_id"], name: "index_chillers_on_staff_id"
    t.index ["updated_by_id"], name: "index_chillers_on_updated_by_id"
  end

  create_table "cleaning_foreign_body_checks", force: :cascade do |t|
    t.date "date"
    t.boolean "milk_pipeline"
    t.boolean "cheese_vat"
    t.boolean "used_mill"
    t.boolean "cooler_moulds_tables"
    t.boolean "hand_equipment"
    t.boolean "blue_food_contact_equipment"
    t.boolean "plastic_sleeves"
    t.boolean "metal_shovels"
    t.boolean "aprons"
    t.boolean "drain_lower_level"
    t.boolean "drain_upper_level"
    t.boolean "presses"
    t.boolean "sinks"
    t.boolean "floor_difficult_areas"
    t.boolean "footbaths"
    t.boolean "internal_door_handles"
    t.boolean "change_chlorine"
    t.boolean "floor_under_handwash"
    t.boolean "compressors"
    t.text "additional_comments"
    t.bigint "staff_id"
    t.bigint "staff_id_2"
    t.bigint "staff_id_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_cleaning_foreign_body_checks_on_created_by_id"
    t.index ["staff_id"], name: "index_cleaning_foreign_body_checks_on_staff_id"
    t.index ["updated_by_id"], name: "index_cleaning_foreign_body_checks_on_updated_by_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "business_name"
    t.string "contact_name"
    t.string "reference"
    t.string "email"
    t.string "mobile"
    t.string "phone"
    t.string "country"
    t.string "address"
    t.boolean "pre_payment"
    t.boolean "payment_on_receipt"
    t.integer "days_after_invoice"
    t.string "terms_and_conditions"
    t.boolean "sage_delivery_note"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_contacts_on_created_by_id"
    t.index ["updated_by_id"], name: "index_contacts_on_updated_by_id"
  end

  create_table "grading_notes", force: :cascade do |t|
    t.bigint "makesheet_id", null: false
    t.date "date"
    t.string "appearance"
    t.string "bore"
    t.string "texture"
    t.string "taste"
    t.integer "score"
    t.text "comments"
    t.integer "head_taster"
    t.integer "assistant_taster_1"
    t.integer "assistant_taster_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_grading_notes_on_created_by_id"
    t.index ["makesheet_id"], name: "index_grading_notes_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_grading_notes_on_updated_by_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "number"
    t.string "account"
    t.date "date"
    t.decimal "amount", precision: 7, scale: 2
    t.decimal "weight", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_invoices_on_created_by_id"
    t.index ["updated_by_id"], name: "index_invoices_on_updated_by_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "location_type"
    t.integer "sort_order"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_locations_on_created_by_id"
    t.index ["updated_by_id"], name: "index_locations_on_updated_by_id"
  end

  create_table "makesheets", force: :cascade do |t|
    t.string "status", default: "Created"
    t.datetime "make_date"
    t.string "make_type"
    t.integer "milk_used"
    t.decimal "expected_yield", precision: 6, scale: 2
    t.float "total_weight"
    t.integer "number_of_cheeses"
    t.string "weight_type"
    t.string "grade"
    t.time "boiler_on_time"
    t.time "steam_hot_water_on_time"
    t.time "cold_milk_in_time"
    t.string "cold_milk_in_state"
    t.time "warm_milk_finish_time"
    t.decimal "warm_milk_finish_titration", precision: 6, scale: 4
    t.time "starter_in_time"
    t.float "starter_in_temp"
    t.time "heat_off_1_time"
    t.float "heat_off_1_temp"
    t.time "milk_titration_time"
    t.float "milk_titration_temp"
    t.time "rennet_time"
    t.float "rennet_temp"
    t.time "cut_start_time"
    t.time "cut_end_time"
    t.time "heat_on_time"
    t.time "heat_off_2_time"
    t.float "heat_off_2_temp"
    t.time "pitch_time"
    t.time "whey_time"
    t.decimal "whey_titration", precision: 6, scale: 3
    t.time "first_cut_time"
    t.decimal "first_cut_titration", precision: 6, scale: 4
    t.time "second_cut_time"
    t.decimal "second_cut_titration", precision: 6, scale: 4
    t.time "third_cut_time"
    t.decimal "third_cut_titration", precision: 6, scale: 4
    t.time "fourth_cut_time"
    t.decimal "fourth_cut_titration", precision: 6, scale: 4
    t.time "fifth_cut_time"
    t.decimal "fifth_cut_titration", precision: 6, scale: 4
    t.time "sixth_cut_time"
    t.decimal "sixth_cut_titration", precision: 6, scale: 4
    t.string "identify_mill_used"
    t.boolean "warm_am"
    t.boolean "twelve_hr_pm"
    t.string "unusual_smell_appearance"
    t.integer "number_of_bottles_from_fm"
    t.datetime "use_by_date_milk_from_fm"
    t.string "type_of_starter_culture_used"
    t.decimal "qty_of_starter_used", precision: 6, scale: 3
    t.boolean "pre_start_inspection_of_high_risk_items"
    t.integer "pre_start_inspection_by_staff_id"
    t.text "ingredient_batch_change"
    t.string "thermometer_change"
    t.string "farm_change"
    t.string "scale_change"
    t.boolean "batch_dipped"
    t.text "post_make_notes"
    t.integer "cheese_made_by_staff_id"
    t.integer "assistant_staff_id"
    t.string "milling_help"
    t.float "salt_weight_net"
    t.float "salt_weight_gross"
    t.string "weather_today"
    t.float "weather_temp"
    t.float "weather_humidity"
    t.boolean "glass_breakage"
    t.boolean "glass_contamination"
    t.text "glass_comments"
    t.boolean "metal_breakage"
    t.boolean "metal_contamination"
    t.text "metal_comments"
    t.boolean "slow_cheese"
    t.boolean "step_1_curd_sample"
    t.boolean "step_2_record_as_slow"
    t.boolean "step_3_record_reason"
    t.boolean "step_4_notify_tim"
    t.boolean "step_5_apply_label"
    t.boolean "step_6_record_red_book"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "batch"
    t.bigint "contact_id"
    t.bigint "location_id"
    t.integer "total_hours"
    t.integer "total_minutes"
    t.decimal "final_titration", precision: 6, scale: 4
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.decimal "ta_combined_milk", precision: 4, scale: 2
    t.decimal "whey_ta", precision: 4, scale: 2
    t.decimal "curd_temp", precision: 3, scale: 1
    t.decimal "room_temp", precision: 3, scale: 1
    t.integer "visual_moisture_post_milling"
    t.decimal "moisture_percentage_post_milling", precision: 4, scale: 2
    t.text "record_of_works_completed"
    t.time "annatto_in_time"
    t.float "annatto_in_temp"
    t.time "md_88_in_time"
    t.float "md_88_in_temp"
    t.text "md_88_qty_used"
    t.index ["contact_id"], name: "index_makesheets_on_contact_id"
    t.index ["created_by_id"], name: "index_makesheets_on_created_by_id"
    t.index ["location_id"], name: "index_makesheets_on_location_id"
    t.index ["make_date"], name: "index_makesheets_on_make_date"
    t.index ["status"], name: "index_makesheets_on_status"
    t.index ["updated_by_id"], name: "index_makesheets_on_updated_by_id"
  end

  create_table "makesheets_samples", id: false, force: :cascade do |t|
    t.bigint "sample_id", null: false
    t.bigint "makesheet_id", null: false
    t.index ["makesheet_id", "sample_id"], name: "index_makesheets_samples_on_makesheet_id_and_sample_id"
    t.index ["sample_id", "makesheet_id"], name: "index_makesheets_samples_on_sample_id_and_makesheet_id"
  end

  create_table "market_sales", force: :cascade do |t|
    t.string "who"
    t.string "market"
    t.date "sale_date"
    t.decimal "cheese_sales", precision: 7, scale: 2
    t.decimal "butter_sales", precision: 7, scale: 2
    t.decimal "honey_sales", precision: 7, scale: 2
    t.decimal "egg_sales", precision: 7, scale: 2
    t.decimal "plum_bread", precision: 7, scale: 2
    t.decimal "milk", precision: 7, scale: 2
    t.decimal "other_cheese", precision: 7, scale: 2
    t.decimal "total_sales", precision: 7, scale: 2
    t.decimal "weight", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_market_sales_on_created_by_id"
    t.index ["market", "sale_date"], name: "index_market_sales_on_market_and_sale_date"
    t.index ["sale_date"], name: "index_market_sales_on_sale_date"
    t.index ["updated_by_id"], name: "index_market_sales_on_updated_by_id"
  end

  create_table "milk_quality_monitors", force: :cascade do |t|
    t.date "sample_date"
    t.bigint "makesheet_id"
    t.integer "cell_count"
    t.integer "bactoscan"
    t.float "butterfat"
    t.float "lactose"
    t.float "protein"
    t.float "casein"
    t.float "urea"
    t.float "total_viable_colonies"
    t.float "therms"
    t.float "coliforms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_milk_quality_monitors_on_created_by_id"
    t.index ["makesheet_id"], name: "index_milk_quality_monitors_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_milk_quality_monitors_on_updated_by_id"
  end

  create_table "palletised_distributions", force: :cascade do |t|
    t.date "date"
    t.string "company_name"
    t.string "registration"
    t.string "trailer_number_type"
    t.float "temperature"
    t.boolean "vehicle_clean"
    t.string "destination"
    t.integer "number_of_pallets"
    t.bigint "staff_id"
    t.text "staff_signature"
    t.text "driver_signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_palletised_distributions_on_created_by_id"
    t.index ["staff_id"], name: "index_palletised_distributions_on_staff_id"
    t.index ["updated_by_id"], name: "index_palletised_distributions_on_updated_by_id"
  end

  create_table "picksheet_items", force: :cascade do |t|
    t.bigint "picksheet_id", null: false
    t.bigint "makesheet_id"
    t.string "product"
    t.string "size"
    t.integer "count"
    t.decimal "weight", precision: 7, scale: 2
    t.string "code"
    t.decimal "sp_price", precision: 7, scale: 2
    t.datetime "bb_date"
    t.string "pricing"
    t.string "custom_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_picksheet_items_on_created_by_id"
    t.index ["makesheet_id"], name: "index_picksheet_items_on_makesheet_id"
    t.index ["picksheet_id"], name: "index_picksheet_items_on_picksheet_id"
    t.index ["updated_by_id"], name: "index_picksheet_items_on_updated_by_id"
  end

  create_table "picksheets", force: :cascade do |t|
    t.datetime "date_order_placed"
    t.datetime "delivery_required_by"
    t.string "delivery_time_of_day"
    t.string "order_number"
    t.string "contact_telephone_number"
    t.string "invoice_number"
    t.string "carrier"
    t.datetime "carrier_delivery_date"
    t.string "carrier_collection_notes"
    t.integer "number_of_boxes"
    t.integer "contact_id", null: false
    t.string "status", default: "Open", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["contact_id"], name: "index_picksheets_on_contact_id"
    t.index ["created_by_id"], name: "index_picksheets_on_created_by_id"
    t.index ["updated_by_id"], name: "index_picksheets_on_updated_by_id"
    t.index ["user_id"], name: "index_picksheets_on_user_id"
  end

  create_table "references", force: :cascade do |t|
    t.string "group"
    t.string "value"
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "model"
    t.integer "sort_order"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_references_on_created_by_id"
    t.index ["updated_by_id"], name: "index_references_on_updated_by_id"
  end

  create_table "samples", force: :cascade do |t|
    t.string "indicator"
    t.string "sample_no"
    t.date "received_date"
    t.string "sample_description"
    t.string "suite"
    t.string "classification"
    t.string "schedule"
    t.string "barcode_count"
    t.string "coagulase_positive_staphylococcus_37c_umqv9"
    t.string "coagulase_positive_staphylococcus_37c_umqzw"
    t.string "escherichia_coli_b_glucuronidase"
    t.string "listeria_species"
    t.string "listeria_species_37"
    t.string "presumptive_coliforms"
    t.string "salmonella"
    t.string "staphylococcus_aureus_enterotoxins"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aerobic_plate_count_22c_3_days"
    t.string "aerobic_plate_count_30c"
    t.string "aerobic_plate_count_37c_2_days"
    t.string "ash"
    t.string "campylobacter_species_10g"
    t.string "campylobacter_species_25g"
    t.string "carbohydrates"
    t.string "crude_protein"
    t.string "energy_kcal"
    t.string "energy_kj"
    t.string "escherichia_coli_100ml"
    t.string "escherichia_coli_o157"
    t.string "fructose"
    t.string "galactose"
    t.string "glucose"
    t.string "histamine"
    t.string "identification_listeria_species_1"
    t.string "lactose"
    t.string "listeria_species_swab"
    t.string "listeria_species_confirmation_maldi"
    t.string "maltose"
    t.string "moisture"
    t.string "monounsaturated_fatty_acids"
    t.string "ph"
    t.string "polyunsaturated_fatty_acids"
    t.string "presumptive_coliforms_swab"
    t.string "presumptive_enterobacteriaceae"
    t.string "salt"
    t.string "saturated_fatty_acids"
    t.string "sodium"
    t.string "sucrose"
    t.string "total_coliforms_100ml"
    t.string "total_dietary_fibre"
    t.string "total_fat"
    t.string "total_sugars"
    t.string "trans_fatty_acids_per_fat"
    t.string "trans_fatty_acids"
    t.string "water_activity"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_samples_on_created_by_id"
    t.index ["updated_by_id"], name: "index_samples_on_updated_by_id"
  end

  create_table "scale_checks", force: :cascade do |t|
    t.string "frequency"
    t.date "check_date"
    t.string "scale_name"
    t.boolean "scale_100g"
    t.boolean "scale_500g"
    t.boolean "scale_1kg"
    t.boolean "scale_5kg"
    t.boolean "scale_10kg"
    t.boolean "scale_20kg"
    t.string "comments"
    t.text "signature"
    t.bigint "staff_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_scale_checks_on_created_by_id"
    t.index ["staff_id"], name: "index_scale_checks_on_staff_id"
    t.index ["updated_by_id"], name: "index_scale_checks_on_updated_by_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "employment_status"
    t.string "dept"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_staffs_on_created_by_id"
    t.index ["updated_by_id"], name: "index_staffs_on_updated_by_id"
  end

  create_table "traceability_records", force: :cascade do |t|
    t.bigint "makesheet_id"
    t.datetime "date_started_batch"
    t.datetime "date_finished_batch"
    t.integer "total_weight_of_batch"
    t.integer "confirmed_number_of_cheeses"
    t.string "all_rinds_visually_clean"
    t.decimal "individual_cheese_weight_1", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_2", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_3", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_4", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_5", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_6", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_7", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_8", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_9", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_10", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_11", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_12", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_13", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_14", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_15", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_16", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_17", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_18", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_19", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_20", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_21", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_22", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_23", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_24", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_25", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_26", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_27", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_28", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_29", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_30", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_31", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_32", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_33", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_34", precision: 7, scale: 2
    t.decimal "individual_cheese_weight_35", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_traceability_records_on_created_by_id"
    t.index ["makesheet_id"], name: "index_traceability_records_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_traceability_records_on_updated_by_id"
  end

  create_table "turns", force: :cascade do |t|
    t.datetime "turn_date"
    t.bigint "makesheet_id", null: false
    t.string "turned_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_turns_on_created_by_id"
    t.index ["makesheet_id"], name: "index_turns_on_makesheet_id"
    t.index ["updated_by_id"], name: "index_turns_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.integer "role"
    t.boolean "account_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "validation_ranges", force: :cascade do |t|
    t.string "target_model"
    t.string "field_name"
    t.float "min_value"
    t.float "max_value"
    t.boolean "active"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wash_picksheets", force: :cascade do |t|
    t.bigint "wash_id", null: false
    t.bigint "picksheet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picksheet_id"], name: "index_wash_picksheets_on_picksheet_id"
    t.index ["wash_id"], name: "index_wash_picksheets_on_wash_id"
  end

  create_table "washes", force: :cascade do |t|
    t.datetime "action_date"
    t.string "wash_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_washes_on_created_by_id"
    t.index ["updated_by_id"], name: "index_washes_on_updated_by_id"
  end

  create_table "waste_records", force: :cascade do |t|
    t.bigint "traceability_record_id", null: false
    t.date "waste_date", null: false
    t.decimal "wedges", precision: 6, scale: 3
    t.decimal "cooking", precision: 6, scale: 3
    t.decimal "blue", precision: 6, scale: 3
    t.decimal "t_and_bs", precision: 6, scale: 3
    t.decimal "waste", precision: 6, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.index ["created_by_id"], name: "index_waste_records_on_created_by_id"
    t.index ["traceability_record_id"], name: "index_waste_records_on_traceability_record_id"
    t.index ["updated_by_id"], name: "index_waste_records_on_updated_by_id"
  end

  add_foreign_key "batch_weights", "makesheets"
  add_foreign_key "batch_weights", "users", column: "created_by_id"
  add_foreign_key "batch_weights", "users", column: "updated_by_id"
  add_foreign_key "breakages", "staffs"
  add_foreign_key "breakages", "users", column: "created_by_id"
  add_foreign_key "breakages", "users", column: "updated_by_id"
  add_foreign_key "butter_makes", "users", column: "created_by_id"
  add_foreign_key "butter_makes", "users", column: "updated_by_id"
  add_foreign_key "butter_stocks", "users", column: "created_by_id"
  add_foreign_key "butter_stocks", "users", column: "updated_by_id"
  add_foreign_key "calculations", "users", column: "created_by_id"
  add_foreign_key "calculations", "users", column: "updated_by_id"
  add_foreign_key "cheese_wash_records", "makesheets"
  add_foreign_key "cheese_wash_records", "users", column: "created_by_id"
  add_foreign_key "cheese_wash_records", "users", column: "updated_by_id"
  add_foreign_key "chillers", "staffs"
  add_foreign_key "chillers", "users", column: "created_by_id"
  add_foreign_key "chillers", "users", column: "updated_by_id"
  add_foreign_key "cleaning_foreign_body_checks", "staffs"
  add_foreign_key "cleaning_foreign_body_checks", "users", column: "created_by_id"
  add_foreign_key "cleaning_foreign_body_checks", "users", column: "updated_by_id"
  add_foreign_key "contacts", "users", column: "created_by_id"
  add_foreign_key "contacts", "users", column: "updated_by_id"
  add_foreign_key "grading_notes", "makesheets"
  add_foreign_key "grading_notes", "users", column: "created_by_id"
  add_foreign_key "grading_notes", "users", column: "updated_by_id"
  add_foreign_key "invoices", "users", column: "created_by_id"
  add_foreign_key "invoices", "users", column: "updated_by_id"
  add_foreign_key "locations", "users", column: "created_by_id"
  add_foreign_key "locations", "users", column: "updated_by_id"
  add_foreign_key "makesheets", "contacts"
  add_foreign_key "makesheets", "locations"
  add_foreign_key "makesheets", "users", column: "created_by_id"
  add_foreign_key "makesheets", "users", column: "updated_by_id"
  add_foreign_key "market_sales", "users", column: "created_by_id"
  add_foreign_key "market_sales", "users", column: "updated_by_id"
  add_foreign_key "milk_quality_monitors", "makesheets"
  add_foreign_key "milk_quality_monitors", "users", column: "created_by_id"
  add_foreign_key "milk_quality_monitors", "users", column: "updated_by_id"
  add_foreign_key "palletised_distributions", "staffs"
  add_foreign_key "palletised_distributions", "users", column: "created_by_id"
  add_foreign_key "palletised_distributions", "users", column: "updated_by_id"
  add_foreign_key "picksheet_items", "makesheets"
  add_foreign_key "picksheet_items", "picksheets"
  add_foreign_key "picksheet_items", "users", column: "created_by_id"
  add_foreign_key "picksheet_items", "users", column: "updated_by_id"
  add_foreign_key "picksheets", "contacts"
  add_foreign_key "picksheets", "users"
  add_foreign_key "picksheets", "users", column: "created_by_id"
  add_foreign_key "picksheets", "users", column: "updated_by_id"
  add_foreign_key "references", "users", column: "created_by_id"
  add_foreign_key "references", "users", column: "updated_by_id"
  add_foreign_key "samples", "users", column: "created_by_id"
  add_foreign_key "samples", "users", column: "updated_by_id"
  add_foreign_key "scale_checks", "staffs"
  add_foreign_key "scale_checks", "users", column: "created_by_id"
  add_foreign_key "scale_checks", "users", column: "updated_by_id"
  add_foreign_key "staffs", "users", column: "created_by_id"
  add_foreign_key "staffs", "users", column: "updated_by_id"
  add_foreign_key "traceability_records", "makesheets"
  add_foreign_key "traceability_records", "users", column: "created_by_id"
  add_foreign_key "traceability_records", "users", column: "updated_by_id"
  add_foreign_key "turns", "makesheets"
  add_foreign_key "turns", "users", column: "created_by_id"
  add_foreign_key "turns", "users", column: "updated_by_id"
  add_foreign_key "wash_picksheets", "picksheets"
  add_foreign_key "wash_picksheets", "washes"
  add_foreign_key "washes", "users", column: "created_by_id"
  add_foreign_key "washes", "users", column: "updated_by_id"
  add_foreign_key "waste_records", "traceability_records"
  add_foreign_key "waste_records", "users", column: "created_by_id"
  add_foreign_key "waste_records", "users", column: "updated_by_id"
end
