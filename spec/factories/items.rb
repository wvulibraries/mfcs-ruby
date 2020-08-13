# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  public_release :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#
FactoryBot.define do
  factory :item do
    idno = Faker::Internet.unique.uuid 

    updated_at { DateTime.now }
    created_at { DateTime.now }
    public_release { Faker::Boolean.boolean }

    factory :metadata do
      data { '{"title": "Some title Field"}' }
      metadata { true }
      idno { nil }   
      association :form, factory: :metadata_form
    end 

    factory :object do
      data { "{'title': '#{Faker::Movies::LordOfTheRings.character}', 'idno':'#{idno}'}" }
      metadata { false }
      idno { idno }
      public_release { Faker::Boolean.boolean }
    end 
  end
end
