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

ActiveRecord::Schema[7.1].define(version: 2025_03_04_120843) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_weights", force: :cascade do |t|
    t.date "date"
    t.bigint "makesheet_id"
    t.decimal "washed_batch_weight", precision: 7, scale: 2
    t.string "all_rinds_visually_clean"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["makesheet_id"], name: "index_batch_weights_on_makesheet_id"
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
    t.index ["staff_id"], name: "index_breakages_on_staff_id"
  end

  create_table "butter_makes", force: :cascade do |t|
    t.date "date"
    t.integer "cream"
    t.integer "make"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "calculations", force: :cascade do |t|
    t.string "product"
    t.string "size"
    t.integer "weight"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["staff_id"], name: "index_chillers_on_staff_id"
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
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "number"
    t.string "account"
    t.date "date"
    t.decimal "amount", precision: 7, scale: 2
    t.decimal "weight", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "makesheets", force: :cascade do |t|
    t.string "status", default: "Created"
    t.datetime "make_date"
    t.string "make_type"
    t.integer "milk_used"
    t.float "total_weight"
    t.integer "number_of_cheeses"
    t.string "weight_type"
    t.string "grade"
    t.time "boiler_on_time"
    t.time "steam_hot_water_on_time"
    t.time "cold_milk_in_time"
    t.string "cold_milk_in_state"
    t.time "warm_milk_finish_time"
    t.float "warm_milk_finish_titration"
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
    t.float "whey_titration"
    t.time "first_cut_time"
    t.float "first_cut_titration"
    t.time "second_cut_time"
    t.float "second_cut_titration"
    t.time "third_cut_time"
    t.float "third_cut_titration"
    t.time "fourth_cut_time"
    t.float "fourth_cut_titration"
    t.time "fifth_cut_time"
    t.float "fifth_cut_titration"
    t.time "sixth_cut_time"
    t.float "sixth_cut_titration"
    t.string "identify_mill_used"
    t.boolean "warm_am"
    t.boolean "twelve_hr_pm"
    t.string "unusual_smell_appearance"
    t.integer "number_of_bottles_from_fm"
    t.datetime "use_by_date_milk_from_fm"
    t.string "type_of_starter_culture_used"
    t.float "qty_of_starter_used"
    t.boolean "pre_start_inspection_of_high_risk_items"
    t.integer "pre_start_inspection_by_staff_id"
    t.text "ingredient_batch_change"
    t.string "thermometer_change"
    t.string "scale_change"
    t.boolean "batch_dipped"
    t.text "post_make_notes"
    t.integer "cheese_made_by_staff_id"
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
    t.index ["make_date"], name: "index_makesheets_on_make_date"
    t.index ["status"], name: "index_makesheets_on_status"
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
    t.index ["market", "sale_date"], name: "index_market_sales_on_market_and_sale_date"
    t.index ["sale_date"], name: "index_market_sales_on_sale_date"
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
    t.index ["makesheet_id"], name: "index_milk_quality_monitors_on_makesheet_id"
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
    t.index ["staff_id"], name: "index_palletised_distributions_on_staff_id"
  end

  create_table "picksheet_items", force: :cascade do |t|
    t.bigint "picksheet_id", null: false
    t.string "product"
    t.string "size"
    t.integer "count"
    t.decimal "weight", precision: 7, scale: 2
    t.string "code"
    t.decimal "sp_price", precision: 7, scale: 2
    t.datetime "bb_date"
    t.string "wedge_size"
    t.string "pricing"
    t.string "custom_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picksheet_id"], name: "index_picksheet_items_on_picksheet_id"
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
    t.integer "number_of_boxes"
    t.integer "contact_id", null: false
    t.string "status", default: "Open", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_picksheets_on_contact_id"
    t.index ["user_id"], name: "index_picksheets_on_user_id"
  end

  create_table "references", force: :cascade do |t|
    t.string "group"
    t.string "value"
    t.string "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.string "indicator"
    t.string "sample_no"
    t.datetime "received_date"
    t.string "sample_description"
    t.bigint "makesheet_id"
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
    t.index ["makesheet_id"], name: "index_samples_on_makesheet_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "employment_status"
    t.string "dept"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traceability_records", force: :cascade do |t|
    t.bigint "makesheet_id"
    t.datetime "date_started_batch"
    t.datetime "date_finished_batch"
    t.integer "total_weight_of_batch"
    t.integer "confirmed_number_of_cheeses"
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
    t.index ["makesheet_id"], name: "index_traceability_records_on_makesheet_id"
  end

  create_table "turns", force: :cascade do |t|
    t.datetime "turn_date"
    t.bigint "makesheet_id", null: false
    t.string "turned_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["makesheet_id"], name: "index_turns_on_makesheet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "email"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false, null: false
    t.integer "role"
    t.boolean "account_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
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
    t.index ["traceability_record_id"], name: "index_waste_records_on_traceability_record_id"
  end

  add_foreign_key "batch_weights", "makesheets"
  add_foreign_key "breakages", "staffs"
  add_foreign_key "chillers", "staffs"
  add_foreign_key "milk_quality_monitors", "makesheets"
  add_foreign_key "palletised_distributions", "staffs"
  add_foreign_key "picksheet_items", "picksheets"
  add_foreign_key "picksheets", "contacts"
  add_foreign_key "picksheets", "users"
  add_foreign_key "samples", "makesheets"
  add_foreign_key "traceability_records", "makesheets"
  add_foreign_key "turns", "makesheets"
  add_foreign_key "wash_picksheets", "picksheets"
  add_foreign_key "wash_picksheets", "washes"
  add_foreign_key "waste_records", "traceability_records"
end
