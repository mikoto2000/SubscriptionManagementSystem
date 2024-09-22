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

ActiveRecord::Schema[7.2].define(version: 2024_09_22_053642) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commission_masters", force: :cascade do |t|
    t.date "from_date", null: false
    t.date "to_date", null: false
    t.decimal "commission_fee", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.exclusion_constraint "daterange(from_date, to_date, '[]'::text) WITH &&", using: :gist, name: "exclude_overlapping_commission_masters"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_publishers_on_email_address", unique: true
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_subscribers_on_email_address", unique: true
  end
end
