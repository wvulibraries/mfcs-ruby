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

ActiveRecord::Schema.define(version: 2021_07_13_205805) do

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "forms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "container", default: false, null: false
    t.boolean "production", default: false, null: false
    t.boolean "metadata", default: false, null: false
    t.boolean "export_public", default: false, null: false
    t.boolean "export_oai", default: false, null: false
    t.boolean "object_public_release_show", default: false, null: false
    t.boolean "object_public_release_default", default: false, null: false
    t.string "submit_button"
    t.string "update_button"
    t.integer "count"
    t.string "display_title"
    t.string "object_title_field"
    t.string "link_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "fields", default: [], array: true
    t.jsonb "navigation", default: [], array: true
    t.jsonb "permissions", default: [], array: true
    t.jsonb "idno", default: {}
    t.index ["idno"], name: "index_forms_on_idno"
  end

  create_table "items", force: :cascade do |t|
    t.integer "form_id"
    t.jsonb "data"
    t.boolean "metadata"
    t.string "idno"
    t.boolean "public_release"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid"
    t.integer "modified_by"
    t.integer "created_by"
  end

  create_table "media", force: :cascade do |t|
    t.integer "form_id"
    t.integer "item_id"
    t.string "filename"
    t.string "path"
    t.string "size"
    t.string "checksum"
    t.jsonb "file_errors"
    t.boolean "virus_scanned"
    t.string "mime_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "media_type"
    t.string "fieldname"
    t.text "ocr_text"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "form_id", null: false
    t.integer "permission"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["form_id"], name: "index_permissions_on_form_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
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

  create_table "watermarks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "permissions", "forms"
  add_foreign_key "permissions", "users"
end
