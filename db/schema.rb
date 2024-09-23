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

ActiveRecord::Schema[7.2].define(version: 2024_09_22_123122) do
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

  create_table "plans", force: :cascade do |t|
    t.bigint "publisher_id", null: false
    t.string "name", null: false
    t.decimal "cost", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id", "name"], name: "index_plans_on_publisher_id_and_name", unique: true
    t.index ["publisher_id"], name: "index_plans_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_publishers_on_email_address", unique: true
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_subscribers_on_email_address", unique: true
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "publisher_id", null: false
    t.bigint "subscriber_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
    t.index ["publisher_id"], name: "index_subscriptions_on_publisher_id"
    t.index ["subscriber_id"], name: "index_subscriptions_on_subscriber_id"
  end

  add_foreign_key "plans", "publishers"
  add_foreign_key "subscriptions", "plans"
  add_foreign_key "subscriptions", "publishers"
  add_foreign_key "subscriptions", "subscribers"
end
