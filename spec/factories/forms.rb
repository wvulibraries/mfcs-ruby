FactoryBot.define do
  faker_title = Faker::Lorem.sentence

  factory :form do
    title { faker_title }
    description { Faker::Lorem.paragraph }
    idno { Faker::Internet.uuid }
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
    display_title { faker_title }
    link_title { faker_title }
  end
end
