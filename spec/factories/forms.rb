FactoryBot.define do
  factory :form do
    title { "MyString" }
    description { "MyText" }
    fields { "" }
    idno { "MyString" }
    container { false }
    production { false }
    metadata { false }
    export_public { false }
    export_oai { false }
    object_public_release_show { false }
    object_public_release_default { false }
    submit_button { "MyString" }
    update_button { "MyString" }
    count { 1 }
    display_title { "MyString" }
    object_title_field { "MyString" }
    navigation { "" }
    link_title { "MyString" }
  end
end
