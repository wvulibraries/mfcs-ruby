# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  container                     :boolean          default(FALSE), not null
#  count                         :integer
#  description                   :text
#  display_title                 :string
#  export_oai                    :boolean          default(FALSE), not null
#  export_public                 :boolean          default(FALSE), not null
#  fields                        :jsonb            is an Array
#  idno                          :jsonb
#  link_title                    :string
#  metadata                      :boolean          default(FALSE), not null
#  navigation                    :jsonb            is an Array
#  object_public_release_default :boolean          default(FALSE), not null
#  object_public_release_show    :boolean          default(FALSE), not null
#  object_title_field            :string
#  permissions                   :jsonb            is an Array
#  production                    :boolean          default(FALSE), not null
#  submit_button                 :string
#  title                         :string
#  update_button                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_forms_on_idno  (idno)
#
FactoryBot.define do
  factory :form do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    container { false }
    production { false }
    metadata { false }
    export_public { true }
    export_oai { false }
    object_public_release_show { false }
    object_public_release_default { false }
    submit_button { "Submit" }
    update_button { "Update" }
    count { 1 }
    display_title { title }
    link_title { title }

    factory :object_form do
      metadata { false }
      production { true }
    end 

    factory :metadata_form do 
      metadata { true }
      production { true }
    end 

    factory :complete_metadata_form do
      metadata { true }
      production { true }
      fields { [{"max"=>"", "min"=>"", "name"=>"title", "type"=>"text", "label"=>"Title", "value"=>"", "css_id"=>"", "format"=>"characters", "hidden"=>false, "disabled"=>false, "field_id"=>"7087986400000518", "help_url"=>"", "required"=>true, "sortable"=>true, "css_class"=>"", "help_info"=>"", "help_type"=>"", "read_only"=>false, "searchable"=>true, "sort_order"=>"1", "validation"=>"", "oai_release"=>false, "placeholder"=>"", "local_styles"=>"", "no_duplicates"=>true, "public_release"=>true, "display_in_list"=>false, "validation_regex"=>"", "disabled_on_insert"=>false, "disabled_on_update"=>false, "metadata_standards"=>""}] }
    end 

    factory :complete_object_form_system do 
      metadata { false }
      production { true }
      fields {[{
        "name" => "idno",
        "type" => "idno",
        "label" => "Identifier",
        "value" => "",
        "css_id" => "",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "9861318229999974",
        "help_url" => "",
        "required" => true,
        "sortable" => true,
        "css_class" => "",
        "help_info" => "For help please go to <a href=\"www.google.com\"> Google </a> and find help for yourself. ",
        "help_type" => "html_text",
        "read_only" => false,
        "managed_by" => "System",
        "searchable" => true,
        "sort_order" => "1",
        "validation" => "",
        "idno_format" => "testing_#########_doh",
        "oai_release" => true,
        "placeholder" => "",
        "local_styles" => "",
        "no_duplicates" => true,
        "public_release" => true,
        "display_in_list" => true,
        "start_increment" => "3",
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }, {
        "max" => "",
        "min" => "",
        "name" => "title",
        "type" => "text",
        "label" => "Title",
        "value" => "",
        "css_id" => "",
        "format" => "characters",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "9861326280000038",
        "help_url" => "",
        "required" => true,
        "sortable" => true,
        "css_class" => "",
        "help_info" => "",
        "help_type" => "",
        "read_only" => false,
        "searchable" => true,
        "sort_order" => "2",
        "validation" => "",
        "oai_release" => false,
        "placeholder" => "",
        "local_styles" => "",
        "no_duplicates" => true,
        "public_release" => true,
        "display_in_list" => false,
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }, {
        "max" => "",
        "min" => "",
        "name" => "email",
        "type" => "text",
        "label" => "Email Validation Stuff",
        "value" => "",
        "css_id" => "",
        "format" => "characters",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "1006207923500007",
        "help_url" => "",
        "required" => true,
        "sortable" => false,
        "css_class" => "",
        "help_info" => "",
        "help_type" => "",
        "read_only" => false,
        "searchable" => false,
        "sort_order" => "3",
        "validation" => "email_addr",
        "oai_release" => false,
        "placeholder" => "test@user.org",
        "local_styles" => "",
        "no_duplicates" => false,
        "public_release" => false,
        "display_in_list" => false,
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }]}
    end 

    factory :complete_object_form_user do 
      metadata { false }
      production { true }
      fields {[{
        "name" => "idno",
        "type" => "idno",
        "label" => "Identifier",
        "value" => "",
        "css_id" => "",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "9861318229999974",
        "help_url" => "",
        "required" => true,
        "sortable" => true,
        "css_class" => "",
        "help_info" => "For help please go to <a href=\"www.google.com\"> Google </a> and find help for yourself. ",
        "help_type" => "html_text",
        "read_only" => false,
        "managed_by" => "User",
        "searchable" => true,
        "sort_order" => "1",
        "validation" => "",
        "idno_format" => "",
        "oai_release" => true,
        "placeholder" => "",
        "local_styles" => "",
        "no_duplicates" => true,
        "public_release" => true,
        "display_in_list" => true,
        "start_increment" => "",
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }, {
        "max" => "",
        "min" => "",
        "name" => "title",
        "type" => "text",
        "label" => "Title",
        "value" => "",
        "css_id" => "",
        "format" => "characters",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "9861326280000038",
        "help_url" => "",
        "required" => true,
        "sortable" => true,
        "css_class" => "",
        "help_info" => "",
        "help_type" => "",
        "read_only" => false,
        "searchable" => true,
        "sort_order" => "2",
        "validation" => "",
        "oai_release" => false,
        "placeholder" => "",
        "local_styles" => "",
        "no_duplicates" => true,
        "public_release" => true,
        "display_in_list" => false,
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }, {
        "max" => "",
        "min" => "",
        "name" => "email",
        "type" => "text",
        "label" => "Email Validation Stuff",
        "value" => "",
        "css_id" => "",
        "format" => "characters",
        "hidden" => false,
        "disabled" => false,
        "field_id" => "1006207923500007",
        "help_url" => "",
        "required" => true,
        "sortable" => false,
        "css_class" => "",
        "help_info" => "",
        "help_type" => "",
        "read_only" => false,
        "searchable" => false,
        "sort_order" => "3",
        "validation" => "email_addr",
        "oai_release" => false,
        "placeholder" => "test@user.org",
        "local_styles" => "",
        "no_duplicates" => false,
        "public_release" => false,
        "display_in_list" => false,
        "validation_regex" => "",
        "disabled_on_insert" => false,
        "disabled_on_update" => false,
        "metadata_standards" => ""
      }]}
    end 
  end
end
