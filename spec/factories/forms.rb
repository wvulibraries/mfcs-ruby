# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  container                     :boolean
#  count                         :integer
#  description                   :text
#  display_title                 :string
#  export_oai                    :boolean
#  export_public                 :boolean
#  fields                        :jsonb            is an Array
#  idno                          :jsonb
#  link_title                    :string
#  metadata                      :boolean
#  navigation                    :jsonb            is an Array
#  object_public_release_default :boolean
#  object_public_release_show    :boolean
#  object_title_field            :string
#  permissions                   :jsonb            is an Array
#  production                    :boolean
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
  faker_title = Faker::Lorem.sentence
  factory :form do
    title { faker_title }
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
    display_title { faker_title }
    link_title { faker_title }
  end
end
