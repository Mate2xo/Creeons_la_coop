# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_04_091518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "postal_code"
    t.string "city"
    t.string "street_name_1"
    t.string "street_name_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adresses_missions", id: false, force: :cascade do |t|
    t.bigint "adress_id", null: false
    t.bigint "mission_id", null: false
    t.bigint "adresses_id"
    t.bigint "missions_id"
    t.index ["adresses_id"], name: "index_adresses_missions_on_adresses_id"
    t.index ["missions_id"], name: "index_adresses_missions_on_missions_id"
  end

  create_table "infos", force: :cascade do |t|
    t.string "content"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "biography"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "missions", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "due_date"
    t.string "member"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "productors", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
