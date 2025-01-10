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

ActiveRecord::Schema[7.0].define(version: 2025_01_10_121321) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "makesheets", force: :cascade do |t|
    t.string "status", default: "Created"
    t.datetime "make_date"
    t.integer "milk_used"
    t.integer "total_weight"
    t.integer "number_of_cheeses"
    t.string "grade"
    t.string "weight_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "batch"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picksheet_id"], name: "index_picksheet_items_on_picksheet_id"
  end

  create_table "picksheets", force: :cascade do |t|
    t.datetime "date_order_placed"
    t.datetime "delivery_required_by"
    t.string "order_number"
    t.string "contact_telephone_number"
    t.string "invoice_number"
    t.string "carrier"
    t.datetime "carrier_delivery_date"
    t.integer "number_of_boxes"
    t.integer "contact_id"
    t.string "status", default: "Open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "make_date"
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
    t.decimal "wedges", precision: 7, scale: 2
    t.decimal "cooking", precision: 7, scale: 2
    t.decimal "blue", precision: 7, scale: 2
    t.decimal "t_and_bs", precision: 7, scale: 2
    t.decimal "waste", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["traceability_record_id"], name: "index_waste_records_on_traceability_record_id"
  end

  add_foreign_key "breakages", "staffs"
  add_foreign_key "chillers", "staffs"
  add_foreign_key "picksheet_items", "picksheets"
  add_foreign_key "traceability_records", "makesheets"
  add_foreign_key "turns", "makesheets"
  add_foreign_key "wash_picksheets", "picksheets"
  add_foreign_key "wash_picksheets", "washes"
  add_foreign_key "waste_records", "traceability_records"
end
