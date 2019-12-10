# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_08_053308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjustments", force: :cascade do |t|
    t.integer "customer_id"
    t.boolean "discount"
    t.boolean "percentage"
    t.float "adjustment_value"
    t.boolean "global_default"
    t.boolean "by_unit"
    t.boolean "by_volume"
    t.boolean "by_weight"
    t.boolean "by_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "conditions", force: :cascade do |t|
    t.bigint "adjustment_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "min_units"
    t.integer "max_units"
    t.float "min_amount"
    t.float "max_amount"
    t.integer "remaining_count"
    t.index ["adjustment_id"], name: "index_conditions_on_adjustment_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.string "company_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "conditions", "adjustments"
end
