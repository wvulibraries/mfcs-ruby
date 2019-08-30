FactoryBot.define do
  factory :idno_field do
    name { 'idno' }
    label { 'IDNO' }
    numbering_type { 0 }
    start_increment { 1 }
    idno_format { "SomeString_###"}
    css_id { 'idno' }
    css_class { nil }
    local_styles { nil }
    help_type { nil }
    help_info { nil }
    type { 'idno' }
    required { true }
    no_duplicates { true }
    read_only { true }
    disabled { nil }
    disabled_on_insert { nil }
    public_release { true }
    oai_release { true }
    sortable { true }
    searchable { true }
    display_in_list { true }
    hidden { nil }
    validation { nil }
    validation_regex { nil }
    placeholder { nil }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
