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

ActiveRecord::Schema[7.0].define(version: 2024_10_01_093704) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calculations", force: :cascade do |t|
    t.string "product"
    t.string "size"
    t.integer "weight"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "makesheets", force: :cascade do |t|
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

  create_table "turns", force: :cascade do |t|
    t.datetime "turn_date"
    t.bigint "makesheet_id", null: false
    t.string "turned_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["makesheet_id"], name: "index_turns_on_makesheet_id"
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

  add_foreign_key "picksheet_items", "picksheets"
  add_foreign_key "turns", "makesheets"
  add_foreign_key "wash_picksheets", "picksheets"
  add_foreign_key "wash_picksheets", "washes"
end
