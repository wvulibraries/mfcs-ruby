FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username(specifier: 2..20) }
    password { Faker::Internet.password }
    active { true }
    student { false }
    form_creator { false }

    trait :admin do
      status { :admin }
      active { true }
    end

    trait :basic do
      status { :user }
      active { true }
    end

    trait :form_creator do
      status { :user }
      active { true }
      form_creator { true }
    end

    trait :editor do
      status { :editor }
      active { true }
    end

    trait :student do
      status { :user }
      active { true }
      student { true }
    end
  end
end
