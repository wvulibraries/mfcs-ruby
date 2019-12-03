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

ActiveRecord::Schema.define(version: 2019_12_03_155516) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
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

  create_table "fields", force: :cascade do |t|
    t.string "field_types_type"
    t.bigint "field_types_id"
    t.bigint "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["field_types_type", "field_types_id"], name: "index_fields_on_field_types_type_and_field_types_id"
    t.index ["form_id"], name: "index_fields_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.hstore "fields"
    t.string "idno"
    t.boolean "container"
    t.boolean "production"
    t.boolean "metadata"
    t.boolean "export_public"
    t.boolean "export_oai"
    t.boolean "object_public_release_show"
    t.boolean "object_public_release_default"
    t.string "submit_button"
    t.string "update_button"
    t.integer "count"
    t.string "display_title"
    t.string "object_title_field"
    t.hstore "navigation"
    t.string "link_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_title"], name: "index_forms_on_display_title", unique: true
    t.index ["fields"], name: "index_forms_on_fields", using: :gin
    t.index ["idno"], name: "index_forms_on_idno", unique: true
    t.index ["navigation"], name: "index_forms_on_navigation", using: :gin
    t.index ["title"], name: "index_forms_on_title", unique: true
  end

  create_table "metadata_mappings", force: :cascade do |t|
    t.integer "schema"
    t.string "identifier"
    t.string "qualifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "field_id"
    t.index ["field_id"], name: "index_metadata_mappings_on_field_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "systems", force: :cascade do |t|
    t.string "name"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "status"
    t.integer "pagination"
    t.boolean "student"
    t.boolean "active"
    t.string "email"
    t.boolean "form_creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "metadata_mappings", "fields"
end
