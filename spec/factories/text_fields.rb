FactoryBot.define do
  factory :text_field do
    name { Faker::Lorem.words(number: 4).join(' ') }
    label { Faker::Lorem.words(number: 4).join(' ') }
    value { Faker::Lorem.words(number: 4).join(' ') }
    css_id { Faker::Lorem.word }
    css_class { Faker::Lorem.word }
  end
end
