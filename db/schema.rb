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

ActiveRecord::Schema.define(version: 2019_08_19_182145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "check_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "choices", default: [], array: true
    t.integer "default_choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "date_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string "field_types_type"
    t.bigint "field_types_id"
    t.bigint "form_id"
    t.index ["field_types_type", "field_types_id"], name: "index_fields_on_field_types_type_and_field_types_id"
    t.index ["form_id"], name: "index_fields_on_form_id"
  end

  create_table "file_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "extensions", default: [], array: true
    t.string "image_options", default: [], array: true
    t.string "audio_options", default: [], array: true
    t.string "video_options", default: [], array: true
    t.integer "thumbnail_height"
    t.integer "thumbnail_width"
    t.string "thumbnail_format"
    t.integer "img_height"
    t.integer "img_width"
    t.string "img_format"
    t.integer "img_dpi"
    t.boolean "img_watermark"
    t.boolean "img_border"
    t.integer "border_height"
    t.integer "border_width"
    t.string "border_color"
    t.integer "watermark_img"
    t.string "watermark_location"
    t.integer "audio_bitrate"
    t.integer "video_bitrate"
    t.string "audio_format"
    t.string "video_format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "idno_fields", force: :cascade do |t|
    t.integer "numbering_type"
    t.string "idno_format"
    t.integer "start_increment"
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "position"
    t.string "validation"
    t.string "validation_regex"
    t.string "placeholder"
  end

  create_table "integer_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.integer "min"
    t.integer "max"
    t.integer "step"
    t.string "validation"
    t.string "validation_regex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metadata_mappings", force: :cascade do |t|
    t.integer "schema"
    t.string "identifier"
    t.string "qualifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "multi_select_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.integer "choice_type"
    t.integer "choice_form_id"
    t.integer "choice_form_field"
    t.string "choices", default: [], array: true
    t.integer "default_choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "radio_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "choices", default: [], array: true
    t.integer "default_choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "select_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.integer "choice_type"
    t.integer "choice_form_id"
    t.integer "choice_form_field"
    t.string "choices", default: [], array: true
    t.integer "default_choice"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "systems", force: :cascade do |t|
    t.string "name"
    t.boolean "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "text_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "min"
    t.integer "max"
    t.integer "format"
    t.integer "position"
    t.string "placeholder"
    t.string "validation"
    t.string "validation_regex"
  end

  create_table "textarea_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "min"
    t.integer "max"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validation"
    t.string "validation_regex"
  end

  create_table "time_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "validation"
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

  create_table "website_fields", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "value"
    t.string "css_id"
    t.string "css_class"
    t.string "local_styles"
    t.string "help_type"
    t.string "help_info"
    t.string "type"
    t.boolean "required"
    t.boolean "no_duplicates"
    t.boolean "read_only"
    t.boolean "disabled"
    t.boolean "disabled_on_insert"
    t.boolean "public_release"
    t.boolean "oai_release"
    t.boolean "sortable"
    t.boolean "searchable"
    t.boolean "display_in_list"
    t.boolean "hidden"
    t.integer "format"
    t.string "placeholder"
    t.integer "position"
    t.string "validation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
