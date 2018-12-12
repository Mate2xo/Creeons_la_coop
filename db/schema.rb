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

ActiveRecord::Schema.define(version: 2018_12_11_181848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "postal_code"
    t.string "city"
    t.string "street_name_1"
    t.string "street_name_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "productor_id"
    t.bigint "member_id"
    t.string "coordonnee"
    t.index ["member_id"], name: "index_addresses_on_member_id"
    t.index ["productor_id"], name: "index_addresses_on_productor_id"
  end

  create_table "addresses_missions", id: false, force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.bigint "address_id", null: false
  end

  create_table "infos", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.index ["author_id"], name: "index_infos_on_author_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.text "biography"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "members_missions", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "mission_id", null: false
  end

  create_table "members_productors", id: false, force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "productor_id", null: false
  end

  create_table "missions", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.index ["author_id"], name: "index_missions_on_author_id"
  end

  create_table "missions_productors", id: false, force: :cascade do |t|
    t.bigint "mission_id", null: false
    t.bigint "productor_id", null: false
  end

  create_table "productors", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "members"
  add_foreign_key "addresses", "productors"
  add_foreign_key "infos", "members", column: "author_id"
  add_foreign_key "missions", "members", column: "author_id"
end
